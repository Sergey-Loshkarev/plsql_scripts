create table news (rn number(6) not null, caption varchar2(200) not null, text varchar2(1000),
constraint news_pk primary key (rn));
select rowid,t.* from news t;
Теперь и сайт!
Ура! Мы решились на публикацию нашего представительства в сети! 
Здесь Вы найдёте последние новости и актуальную информацию о нашей организации. 
Добро пожаловать! 
alter table news add ndate date;
create table pdata (rn number(6) not null, dbeg date, dend date, constraint pdata_pk primary key (rn));
select rowid, t.* from pdata t;
alter table pdata add storno number(1);
