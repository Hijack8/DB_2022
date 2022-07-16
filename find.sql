# No 1
# 选修课程CS -2 的学生学号成绩
SELECT Sno,grade
FROM SC
WHERE sc.Cno = 'CS-02';

# No 2
# 选修课程EE-01的女生姓名
SELECT sname
FROM sc,Student
WHERE sc.sno = Student.sno
AND sc.cno = 'EE-01'
and Student.Sex = '女';

# No 3
# 不选修课程CS-02的学生姓名
select count(*) from(
SELECT sname
from Student
WHERE not EXISTS(
  SELECT * 
  FROM SC
  WHERE sc.sno = Student.sno
  and sc.cno = 'CS-02')) as s;
select count(*) from 
(
select sname
from student
where sno not in 
(
select sno 
from  sc 
where sc.Cno = 'CS-02'
) 
) as table1;

# 错误示范  这样得到的结果是错误的
select Sname
from Student,SC
where Student.Sno = SC.Sno
and SC.Cno <> 'CS-02';

# No 4
# 查询身高比王涛高的同学 的男生学号姓名和年龄
select count(*)
from (
SELECT sno,sname,TIMESTAMPDIFF(year,bdate,now()) as age
FROM Student s1
WHERE EXISTS(
  SELECT * 
  from Student s2
  WHERE s1.height > s2.height
  and s2.sname = '李一'
  )
  and s1.sex = '男') as s;
  
select count(*)
from(
select sno,sname
from student 
where sex = '男'
and height > any (
	select height 
    from student
    where Sname = '李一'
)) as s;
# No 5
insert into student values('20000000','小李','男','2001-9-4','1.84');
insert into sc values('20000000','CS-01',NULL);

select Sno,AVG(Grade)
from sc
group by Sno
Having 
avg(Grade) is not NULL
and
AVG(Grade) >=
all (select (AVG(Grade))
from SC
group by Sno
having avg(Grade) is not NULL);

select sno 
from sc 
where cno = 'CS-01'
and Grade in 
(
	select max(Grade) 
    from sc
    where cno = 'CS-01'
);

select Sno
from(
select Sno,max(avg_grade)
from
	(
	select SC.Sno,AVG(Grade) as avg_grade
	from SC,Student
	where SC.Sno = student.sno
	and SC.Sno in 
		(
		select distinct SC1.Sno  
		from SC SC1
		where Cno = 'CS-01'
		)
	group by SC.Sno 
	) as s
) AS B;
select Sno 
from (
select Sno,MAX(Grade)
from SC
where SC.Cno = 'CS-01'
AND SC.Grade is not null
)as s;
from SC
# 这个用法是错误的，因为两个统计函数一般不能重叠使用
select Sno,Cno,max(Grade)
from SC;

# 使用排序的方法，找出最大值，但是无法处理全NULL值
select Sno
from sc
group by Sno
order by avg(Grade)
limit 1;

# No 6
# 查询学生姓名以及修课程的课程号 学分和成绩
# 这里是使用的等值连接查询
select student.Sname, Course.Cno,Course.Credit,SC.Grade
from Student,course,SC
where student.Sno = SC.Sno
AND Course.Cno = SC.Cno;

# No 7
# 查询平均成绩超过80分的学生姓名和平均成绩
select Sname,AVG(Grade)
from Student,SC
where Student.Sno = SC.Sno
group by SC.Sno
having AVG(Grade) > 80; 

# No 8
# 查询选修三门以上课程的学生，已经获得的学分数 并按照学号进行升序排列
# 首先筛选出有效的成绩
# 然后再根据这个表匹配学号
# 对这些学号 group
# 求出Credit的和

select sum(Course.Credit) as sum_credit,SC.Sno
from Course,SC
where Course.Cno = SC.Cno  
and SC.Grade >= 60
group by SC.Sno
having SC.Sno in
(
select Sno 
from SC
group by Sno
having count(*) >= 3
)
union 
select 0 as sum_Credit,SC.Sno
from SC,Course
where SC.Cno = Course.Cno
and (SC.Grade < 60 or SC.Grade is null)
group by Sno
having  count(*) >= 3
and sum(Grade) is null
order by Sno ASC;


	select sum(Credit)
    from 
		(
		select sno 
		from sc
		group by sno 
		having count(*) >= 3
		) as sc_1
	left outer join
		(
		select sno,cno,grade 
		from sc
		where grade >= 60
		)as sc_2 
	on (sc_1.sno = sc_2.sno)
    left outer join 
	course 
    on (sc_2.cno = course.cno)
    group by sc_1.sno
    order by sc_1.sno
    ;

select * 
from sc
order by sno
;


and (SC.Grade is not null or sum(SC.Grade) is NULL)
Group by SC.Sno
#having count(*) >= 3 
order by SC.Sno ASC;

# 3.3 
# 添加记录
insert into Student values('01032005','刘静','男','1983-12-10',1.75);
insert into Course values('CS-09','离散数学',4,'陈建明');

# 3.4
# 查询并删除
delete from Student
where Sno in
(select SC.Sno 
from SC,Course
where SC.Cno = Course.Cno
and SC.Grade is not null
group by Sno
having sum(Course.Credit) > 110
);



# 3.5
# 调整数据
select * 
from Course;

select *
from student;

update C575
set Credit = Credit + 1,  PERIOD = 64
where Cname = '信号与系统' 
and Teacher = '张明';

