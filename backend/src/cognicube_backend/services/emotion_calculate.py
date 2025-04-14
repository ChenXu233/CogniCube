from datetime import datetime

from cognicube_backend.models.emotion_record import EmotionRecord


def calculate_emotion_level(records: list[EmotionRecord]):
    if not records:
        return "中性", 50.0

    emotion_categories = {
        "高兴": (80, 100),
        "平静": (60, 80),
        "中性": (40, 60),
        "悲伤": (20, 40),
        "抑郁": (0, 20),
    }

    # 计算时间加权平均
    total_weight = 0.0
    weighted_score = 0.0

    for record in records:
        # 计算时间权重，越近的记录权重越高
        time_diff = (datetime.now() - record.time).total_seconds() / 3600  # 小时为单位
        time_weight = 1 / (1 + time_diff)  # 时间衰减因子

        # 将各指标转换到0-100范围
        intensity = record.intensity_score * 100
        valence = (record.valence + 1) / 2 * 100  # 将-1~1转换为0~100
        arousal = record.arousal * 100
        dominance = record.dominance * 100

        # 综合得分计算（考虑时间权重）
        # 强度得分占40%，效价占30%，唤醒度和优势度各占15%
        score = intensity * 0.4 + valence * 0.3 + arousal * 0.15 + dominance * 0.15

        # 应用时间权重
        weighted_score += score * time_weight
        total_weight += time_weight

    if total_weight == 0:
        avg_score = 0
    else:
        avg_score = weighted_score / total_weight

    # 确定情感类型
    emotion_type = "中性"
    for category, (lower, upper) in emotion_categories.items():
        if lower <= avg_score < upper:
            emotion_type = category
            break

    emotion_level = avg_score

    return emotion_type, emotion_level
