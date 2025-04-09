from unittest.mock import AsyncMock, MagicMock, patch

import pytest
from sqlalchemy.orm import Session

from cognicube_backend.services.ai_service import AIChatService

# filepath: tests/test_ai_service.py


@pytest.fixture
def mock_db_session():
    """Fixture to mock the database session."""
    return MagicMock(spec=Session)


@pytest.fixture
def ai_chat_service(mock_db_session):
    """Fixture to initialize AIChatService with mocked dependencies."""
    return AIChatService(user_id=1, db=mock_db_session)


@patch("..cognicube_backend.services.ai_service.get_ai_session", new_callable=AsyncMock)
async def test_chat(mock_get_ai_session, ai_chat_service):
    """Test the chat method."""
    mock_client = AsyncMock()
    mock_get_ai_session.return_value = mock_client
    mock_client.chat.completions.create.return_value = {
        "choices": [{"message": {"content": "Test response"}}]
    }

    user_message = "Hello, AI!"
    response = await ai_chat_service.chat(user_message)

    assert response["choices"][0]["message"]["content"] == "Test response"
    mock_client.chat.completions.create.assert_called_once()


def test_get_context_manager(ai_chat_service, mock_db_session):
    """Test the get_context_manager method."""
    mock_db_session.query.return_value.filter_by.return_value.first.return_value = None
    context_manager = ai_chat_service.get_context_manager()

    assert context_manager.user_id == 1
    mock_db_session.add.assert_called_once()


def test_update_context_manager(ai_chat_service, mock_db_session):
    """Test the update_context_manager method."""
    mock_context = MagicMock()
    ai_chat_service.context_manager = mock_context
    mock_db_session.query.return_value.filter_by.return_value.first.return_value = (
        mock_context
    )

    ai_chat_service.update_context_manager()

    mock_db_session.commit.assert_called_once()


@patch("..cognicube_backend.services.ai_service.get_ai_session", new_callable=AsyncMock)
async def test_emotion_quantification(mock_get_ai_session, ai_chat_service):
    """Test the emotion_quantification method."""
    mock_client = AsyncMock()
    mock_get_ai_session.return_value = mock_client
    mock_client.chat.completions.create.return_value = {
        "choices": [
            {
                "message": {
                    "content": '{"emotion_type": "happy", "intensity_score": 0.8, "valence": 0.9, "arousal": 0.7}'
                }
            }
        ]
    }

    user_message = "I feel great!"
    emotion_record = await ai_chat_service.emotion_quantification(user_message)

    assert emotion_record.emotion_type == "happy"
    assert emotion_record.intensity_score == 0.8
    mock_db_session.add.assert_called_once()
    mock_db_session.commit.assert_called_once()


def test_save_message_record(ai_chat_service, mock_db_session):
    """Test the save_message_record method."""
    mock_message = MagicMock()
    mock_message.model_dump.return_value = {"content": "Test message"}

    ai_chat_service.save_message_record(user_id=1, message=mock_message)

    mock_db_session.add.assert_called_once()
    mock_db_session.commit.assert_called_once()
