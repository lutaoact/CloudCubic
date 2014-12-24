
Const =
  NoticeType:
    TopicVoteUp: 1
    ReplyVoteUp: 2
    Comment: 3
    Lecture: 4

  Notification:
    1: '有人赞了你的话题'
    2: '有人赞了你的回复'
    3: '有人给你评论啦^_^'
    4: '新的课时发布啦'

  OrgType:
    Primary     : 1  # 小学
    JuniorMiddle: 2  # 初中
    HighMiddle  : 3  # 高中
    University  : 4  # 大学
    College     : 5  # 职业学校
    Institute   : 6  # 培训机构
    Company     : 7  # 企业
    Other       : 10 # 其他

  MsgType:
    Login: 'login'
    Notice: 'notice'
    Quiz: 'quiz'
    QuizAnswer: 'quiz_answer'
    Error: 'error'

  CommentType:
    DisTopic: 1
    Course: 2
    Lecture: 3
    Teacher: 4

  CommentRef:
    1: 'dis_topic'
    2: 'course'
    3: 'lecture'
    4: 'user'

  NoticeRef:
    1: 'disTopic'
    2: 'disReply'
    3: 'disReply'
    4: 'lecture'

  PageSize:
    DisTopic: 10
    DisReply: 36
    Lecture: 30
    Course: 10
    Question: 300
    Order: 10

  QuestionType:
    Choice: 1
    Blank:  2

  Student:
    ViewLecture: 1

  Teacher:
    ViewLecture: 101 # start teaching view
    EditLecture: 102

  Demo:
    StudentId: 'ffffffffffff000000000%03d'
    TeacherId: 'ffffffffffff000000001000'
    ClasseId:  'ffffffffffff000000010000'
    CourseId:  'ffffffffffff000000100000'
    UserNum: if process?.env?.NODE_ENV is 'development' then 10 else 1000


module?.exports = Const
window?.Const = Const
