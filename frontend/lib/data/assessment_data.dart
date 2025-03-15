import '../models/assessment_model.dart';

final List<Assessment> assessments = [
  Assessment(
    id: 'phq-9',
    title: 'PHQ-9抑郁筛查量表',
    description: '过去两周内，以下情况出现的频率如何？',
    questions: [
      Question(
        text: '做事时提不起劲或没有兴趣',
        options: ['完全不会', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '感到心情低落、沮丧或绝望',
        options: ['完全不会', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      // 添加其他问题...
    ],
  ),
  Assessment(
    id: 'gad-7',
    title: 'GAD-7焦虑量表',
    description: '过去两周内，以下问题困扰你的程度如何？',
    questions: [
      Question(
        text: '感觉紧张、焦虑或急切',
        options: ['完全没有', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      // 添加其他问题...
    ],
  ),
];
