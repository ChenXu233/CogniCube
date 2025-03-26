import '../models/assessment_model.dart';

final List<Assessment> assessments = [
  Assessment(
    id: 'phq-9',
    title: 'PHQ-9抑郁筛查量表',
    type: 'phq9',
    description: '过去两周内，有多少时间您被以下问题所困扰？',
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
      Question(
        text: '人睡困难、很难熟睡或睡太多',
        options: ['完全不会', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '感到疲劳或无精打采',
        options: ['完全不会', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '胃口不好或吃太多',
        options: ['完全不会', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '觉得自己很糟，或很失败，或让自己或家人失望',
        options: ['完全不会', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '注意很难集中，例如阅读报纸或看电视',
        options: ['完全不会', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '动作或说话速度缓慢到别人可察觉的程度，或正好相反—您烦躁或坐立不安，动来动去的情况比平常更严重',
        options: ['完全不会', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '有不如死掉或用某种方式伤害自己的念头',
        options: ['完全不会', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
    ],
  ),
  Assessment(
    id: 'gad-7',
    title: 'GAD-7焦虑量表',
    type: 'gad7',
    description: '过去两周内，以下问题困扰你的程度如何？',
    questions: [
      Question(
        text: '感觉紧张、焦虑或急切',
        options: ['完全没有', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '不能停止或控制担忧',
        options: ['完全没有', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '对各种各样的事情担忧过多',
        options: ['完全没有', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '很难放松下来',
        options: ['完全没有', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '由于不安而无法静坐',
        options: ['完全没有', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '变得容易烦恼或急躁',
        options: ['完全没有', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
      Question(
        text: '害怕将有可怕的事发生',
        options: ['完全没有', '几天', '一半以上天数', '几乎每天'],
        correctIndex: 0,
      ),
    ],
  ),
];
