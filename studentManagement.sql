drop table courses;
drop table courseRegistration;
drop table students;
drop table teachers;

create table teachers(
	teacherId int,
	teacherName varchar(20),
	teacherGrade varchar(20),
	primary key(teacherId)
);


create table students(
	studentId int,
	studentName varchar(15),
	studentHall varchar(15),
	studentEmail varchar(20),
	studentDistrict varchar(15),
	studentDateofbirdh date,
	studentAge int,
	teacherId int,
	primary key(studentId),
	foreign key(teacherId) references teachers(teacherId) on delete cascade
);

create table courses(
	courseId varchar(8),
	courseName varchar(20),
	courseCredit number(3,2),
	courseCreditHour number(3,2),
	teacherId int,
	primary key(courseId)
);


create table courseRegistration(
	registrationID int,
	studentId int unique,
	courseId1 varchar(8),
	courseId2 varchar(8),
	courseId3 varchar(8),
	courseId4 varchar(8),
	courseId5 varchar(8),
	primary key(registrationID),
	foreign key(studentId)   references students(studentId) on delete cascade
);


create or replace trigger calculate_age before insert or update on students for each row
BEGIN
	:new.studentAge := floor(Months_between(sysdate, :new.studentDateofbirdh)/12);
END;
/
 
insert into students(studentId, studentName,  studentHall, studentEmail, studentDistrict, studentDateofbirdh) values (1107001, 'Shuvo', 'Lalan','shuvo@g.com','Tangail','18-FEB-1992');
insert into students(studentId, studentName,  studentHall, studentEmail, studentDistrict, studentDateofbirdh) values (1107002, 'Sun', 'Lalan','sun@gmail.com','Rangpur','13-AUG-1993');
insert into students(studentId, studentName,  studentHall, studentEmail, studentDistrict, studentDateofbirdh) values (1107003, 'Raju', 'Bongo','raju@g.com','Dhaka','11-JUL-1992');
insert into students(studentId, studentName,  studentHall, studentEmail, studentDistrict, studentDateofbirdh) values (1107021, 'Mostafiz', 'Ekush','bota@y.com','Thakurgone','25-MAR-1991');
insert into students(studentId, studentName,  studentHall, studentEmail, studentDistrict, studentDateofbirdh) values (1107039, 'Ashik', 'Bongo','kutta@h.com','Pabna','23-SEP-1990');

insert into courses(courseId, courseName, courseCredit, courseCreditHour, teacherId) values ('CSE 1101', 'Programming', 2.00, 3.00, 0701);
insert into courses(courseId, courseName, courseCredit, courseCreditHour, teacherId) values ('CSE 1207', 'Discrete Math', 3.00, 3.00, 0705);
insert into courses(courseId, courseName, courseCredit, courseCreditHour, teacherId) values ('CSE 2107', 'Algorithms', 4.00, 4.00, 0707);
insert into courses(courseId, courseName, courseCredit, courseCreditHour, teacherId) values ('CSE 3111', 'Database', 3.00, 3.00, 0702);
insert into courses(courseId, courseName, courseCredit, courseCreditHour, teacherId) values ('CSE 3101', 'TO Computation', 2.00, 3.00, 0702);
insert into courses(courseId, courseName, courseCredit, courseCreditHour, teacherId) values ('CSE 4101', 'Graph Theory', 4.00, 4.00, 0715); 
insert into courses(courseId, courseName, courseCredit, courseCreditHour, teacherId) values ('CSE 4211', 'M Learning', 3.75, 3.00, 0705); 

insert into teachers(teacherId, teacherName, teacherGrade) values (0701, 'Hashem', 'Professor');
insert into teachers(teacherId, teacherName, teacherGrade) values (0702, 'Azhar', 'Professor');
insert into teachers(teacherId, teacherName, teacherGrade) values (0705, 'Jakaria', 'Ass. Professor');
insert into teachers(teacherId, teacherName, teacherGrade) values (0707, 'Rana', 'Lecturer');
insert into teachers(teacherId, teacherName, teacherGrade) values (0715, 'Fairose', 'Lecturer');


insert into courseRegistration(registrationID, studentId, courseId1, courseId2,courseId3, courseId4,courseId5) values (1,1107002, 'CSE 1107', 'CSE 1207', 'CSE 2107','CSE 4101','CSE 4211');
insert into courseRegistration(registrationID, studentId, courseId1, courseId2,courseId3, courseId4,courseId5) values (2,1107001, 'CSE 1107', 'CSE 1207', 'CSE 3101','CSE 3111','CSE 4211');
insert into courseRegistration(registrationID, studentId, courseId1, courseId2,courseId3, courseId4,courseId5) values (3,1107021, 'CSE 1107', 'CSE 1207', 'CSE 3101','CSE 4101','CSE 4211');
insert into courseRegistration(registrationID, studentId, courseId1, courseId2,courseId3, courseId4,courseId5) values (4,1107039, 'CSE 1107', 'CSE 1207', 'CSE 3111','CSE 4101','CSE 4211');

select studentId as id, studentName as name, studentHall as hall, studentage as age from students;
select courseId as Code, courseName as name, courseCredit as credit from courses;
select teacherId as id, teacherName as name, teacherGrade as Grade from teachers;

-- The name of the teachers who have at least one course
select teacherId, teacherName from teachers where teacherId IN(select distinct teacherId from courses) order by teacherId asc;

-- Display courses with assigning teachers
select courses.courseId, courses.courseName,teachers.teacherId, teachers.teacherName from teachers,courses where courses.teacherId = teachers.teacherId;

-- Name of the students who have registered
select studentId as id, studentName as Name from students where studentId in (select studentId from courseRegistration ) order by studentId asc;  

-- show the students name and their taken courses


-- Select the name of students with highest character name , if length same then sort alphabatically and limit row numbers.
select studentName, studentId from  (select * from students order by length(studentName) desc, studentName asc) where rownum <= 2;


-- Let NUM be the number of teacherID entries in courses, and NUMunique be the number of unique teacherIDs. Query the value of NUM−NUMunique from Courses.
select count(teacherID)-count(distinct(teacherId)) from courses;

--Query the list of studentNames starting with vowels (A,S) from students.Result cannot contain duplicates.
select distinct(studentName) from students where studentName like 'A%' or studentName like 'S%';

----Query the list of studentNames not starting with vowels (A,S) from students.Result cannot contain duplicates.
select distinct(studentName) from students where studentName not like 'A%' and studentName not like 'S%';

-- Ordering output by the last three characters of each studentName from students 
-- substr(stringName, range1, range2) if no range1, then it will last characters from range2 
select studentName from students order by  substr(studentName, length(studentName)-2);
select studentName from students order by  substr(studentName, 0,2);


-- summation of courseCredit and courseCreditHour and rounding it after 2 decimal place and show them seperated by a space
SET SERVEROUTPUT on;
	DECLARE 
		courseCreditSum number;
        courseCreditHourSum number;
	BEGIN
		select sum(courseCredit) into courseCreditSum from courses;
        select sum(courseCreditHour) into courseCreditHourSum from courses;

		DBMS_OUTPUT.PUT_LINE(round(courseCreditSum,2) || ' '|| round(courseCreditHourSum,2));
	END;
/


-- select the name of the teacher and their respective total courseCredit taken
select teachers.teacherName, sum(courses.courseCredit) from courses, teachers where teachers.teacherId = courses.teacherId group by  teachers.teacherName;

