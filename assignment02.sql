-- Q1
-- 55 rows returned

create or replace view Q1(Name) as
select person.name
from 
	person 
inner join 
	(select distinct editorid
	from 
		proceeding) as a1
on person.personid = a1.editorid;

-- Q2
-- 39 rows returned

create or replace view Q2(Name) as
select person.name
from 
	person 
inner join
	(select distinct proceeding.editorid as editorid
	from 
		proceeding 
	inner join 
		relationpersoninproceeding
	on proceeding.editorid = relationpersoninproceeding.personid) as a1
on person.personid = a1.editorid;

-- Q3
-- 19 rows returned

create or replace view Q3(Name) as
select person.name
from 
	person 
inner join
	(select distinct proceeding.editorid as editorid
	from 
		proceeding
	inner join
		(select inproceeding.proceedingid as proceedingid, relationpersoninproceeding.personid as personid
		from 
			inproceeding 
		inner join 
			relationpersoninproceeding
		on inproceeding.inproceedingid = relationpersoninproceeding.inproceedingid) as a1
	on proceeding.editorid = a1.personid and proceeding.proceedingid = a1.proceedingid) as a2
on person.personid = a2.editorid;

-- Q4
-- 31 rows returned

create or replace view Q4(Title) as
select a1.title
from
	proceeding
inner join
	(select inproceeding.proceedingid as proceedingid, inproceeding.title as title, relationpersoninproceeding.personid as personid
	from
		inproceeding
	inner join 
		relationpersoninproceeding
	on inproceeding.inproceedingid = relationpersoninproceeding.inproceedingid) as a1
on proceeding.editorid = a1.personid
where proceeding.proceedingid = a1.proceedingid;

-- Q5
-- 2 rows returned

create or replace view Q5(Title) as
select a1.title
from
	person
inner join
	(select relationpersoninproceeding.personid as personid, inproceeding.title as title
	from
		inproceeding
	inner join
		relationpersoninproceeding
	on inproceeding.inproceedingid = relationpersoninproceeding.inproceedingid) as a1
on person.personid = a1.personid
where person.name ilike '% Clark';

-- Q6
-- 18 rows returned, ordered by year of publication in ascending order
-- research papers with unknown year of publication, and years with no publication, not included

create or replace view Q6(Year, Total) as
select proceeding.year, count(inproceeding.title)
from
	proceeding
inner join
	inproceeding
on proceeding.proceedingid = inproceeding.proceedingid
where proceeding.year is not null
group by proceeding.year
having count(inproceeding.title) > 0
order by proceeding.year;

-- Q7
-- 1 row returned (Springer)

create or replace view Q7(Name) as
select publisher.name
from 
	publisher
inner join
	(select a1.publisherid as publisherid
	from
		(select proceeding.publisherid as publisherid, count(inproceeding.title) as count_title
		from
			proceeding
		inner join
			inproceeding
		on proceeding.proceedingid = inproceeding.proceedingid
		group by publisherid) as a1
	inner join
		(select max(a2.count_title) as max_count_title
		from
			(select proceeding.publisherid as publisherid, count(inproceeding.title) as count_title
			from
				proceeding
			inner join
				inproceeding
			on proceeding.proceedingid = inproceeding.proceedingid
			group by publisherid) as a2
		) as a3
	on a1.count_title = a3.max_count_title) as a4
on publisher.publisherid = a4.publisherid;

-- Q8
-- 2 rows returned

create or replace view Q8(Name) as
select person.name
from
	person
inner join
	(select a2.personid
	from
		(select relationpersoninproceeding.personid as personid, count(a1.inproceedingid) as count_inproceeding
		from
			relationpersoninproceeding
		inner join
			(select inproceedingid, count(personid) as count_personid
			from
				relationpersoninproceeding
			group by inproceedingid
			having count(personid) > 1) as a1
		on relationpersoninproceeding.inproceedingid = a1.inproceedingid
		group by relationpersoninproceeding.personid) as a2
	inner join
		(select max(count_inproceeding) as max_count_inproceeding
		from
			(select relationpersoninproceeding.personid as personid, count(a3.inproceedingid) as count_inproceeding
			from
				relationpersoninproceeding
			inner join
				(select inproceedingid, count(personid) as count_personid
				from
					relationpersoninproceeding
				group by inproceedingid
				having count(personid) > 1) as a3
			on relationpersoninproceeding.inproceedingid = a3.inproceedingid
			group by relationpersoninproceeding.personid) as a4
		) as a5
	on a2.count_inproceeding = a5.max_count_inproceeding) as a6
on person.personid = a6.personid;
	
-- Q9
-- 435 rows returned

create or replace view Q9(Name) as
select person.name
from
	person
inner join
	(select distinct a1.personid as personid
	from
		relationpersoninproceeding as a1
	inner join
		relationpersoninproceeding as a2
	on a1.inproceedingid = a2.inproceedingid
	group by a1.personid
	having count(distinct a2.personid) = 1) as a3
on person.personid = a3.personid;

-- Q10
-- 3358 rows returned, ordered by total number of co-authors in descending order, followed by author names in ascending order
-- total number of co-authors is 0 for authors that never co-author

create or replace view Q10(Name, Total) as
select person.name, a3.count_personid
from
	person
inner join
	(select distinct a1.personid as personid, count(distinct a2.personid) - 1 as count_personid
	from
		relationpersoninproceeding as a1
	inner join
		relationpersoninproceeding as a2
	on a1.inproceedingid = a2.inproceedingid
	group by a1.personid) as a3
on person.personid = a3.personid
order by a3.count_personid desc, person.name;

-- Q11
-- 3289 rows returned

create or replace view Q11(Name) as
select person.name
from
	person
inner join
	(select distinct a5.personid
	from
		(select distinct personid as personid
		from
			relationpersoninproceeding) as a5
	left join
		(select distinct a1.personid as personid
		from
			relationpersoninproceeding as a1
		inner join
			relationpersoninproceeding as a2
		on a1.inproceedingid = a2.inproceedingid and a1.personid != a2.personid
		where a1.personid in
			(select personid
			from
				person
			where name ilike 'Richard %')
		or a2.personid in
			(select personid
			from
				person
			where name ilike 'Richard %')
		or a1.personid in
			(select distinct a3.personid
			from
				relationpersoninproceeding as a3
			inner join
				relationpersoninproceeding as a4
			on a3.inproceedingid = a4.inproceedingid and a3.personid != a4.personid
			where a3.personid in
				(select personid
				from
					person
				where name ilike 'Richard %')
			or a4.personid in
				(select personid
				from
					person
				where name ilike 'Richard %'))
		or a2.personid in
			(select distinct a3.personid
			from
				relationpersoninproceeding as a3
			inner join
				relationpersoninproceeding as a4
			on a3.inproceedingid = a4.inproceedingid and a3.personid != a4.personid
			where a3.personid in
				(select personid
				from
					person
				where name ilike 'Richard %')
			or a4.personid in
				(select personid
				from
					person
				where name ilike 'Richard %'))
		) as a6
	on a5.personid = a6.personid
	where a6.personid is null) as a7
on person.personid = a7.personid
where person.name not ilike 'Richard %';

-- Q12
-- 149 rows returned

create or replace view Q12(Name) as
with recursive coauthors(personid) as (
	select distinct a1.personid as personid
	from
		relationpersoninproceeding as a1
	inner join
		relationpersoninproceeding as a2
	on a1.inproceedingid = a2.inproceedingid and a1.personid != a2.personid
	where a2.personid in
		(select personid
		from
			person
		where name ilike 'Richard %')
union	
	select distinct a5.personid1 as personid
	from
		(select distinct a3.personid as personid1, a4.personid as personid2
		from
			relationpersoninproceeding as a3
		inner join
			relationpersoninproceeding as a4
		on a3.inproceedingid = a4.inproceedingid and a3.personid != a4.personid) as a5
	inner join
		coauthors as a6
	on a5.personid2 = a6.personid and a5.personid1 != a6.personid
)
select person.name
from
	person
inner join
	(select distinct personid
	from
		coauthors) as a7
on person.personid = a7.personid
where person.name not ilike 'Richard %';

-- Q13
-- 3358 rows returned, ordered by total number of publications in descending order, followed by author names in ascending order
-- if none of the author's publications have year information, both first and last years of publication have "unknown" as output

create or replace view Q13(Author, Total, FirstYear, LastYear) as
select person.name, a2.count_inproceedingid, a2.min_year, a2.max_year
from
	person
inner join
	(select a1.personid as personid, count(a1.inproceedingid) as count_inproceedingid, coalesce(min(proceeding.year), 'unknown') as min_year, coalesce(max(proceeding.year), 'unknown') as max_year
	from
		proceeding
	right join
		(select relationpersoninproceeding.personid as personid, inproceeding.*
		from
			relationpersoninproceeding
		inner join
			inproceeding
		on relationpersoninproceeding.inproceedingid = inproceeding.inproceedingid) as a1
	on proceeding.proceedingid = a1.proceedingid
	group by a1.personid) as a2
on person.personid = a2.personid
order by a2.count_inproceedingid desc, person.name;

-- Q14
-- 1 row returned (288)
-- editors with no papers published in the database research area not included

create or replace view Q14(Total) as
select count(distinct a1.personid)
from
	proceeding
right join
	(select relationpersoninproceeding.personid as personid, inproceeding.*
	from
		inproceeding
	inner join
		relationpersoninproceeding
	on inproceeding.inproceedingid = relationpersoninproceeding.inproceedingid) as a1
on proceeding.proceedingid = a1.proceedingid
where a1.title ilike '%data%' or proceeding.title ilike '%data%';

-- Q15
-- 59 rows returned, ordered by total number of papers in the proceeding in descending order, followed by year in ascending order, followed by titles in ascending order
-- proceedings with no papers published not included
-- proceedings with no editors not included

create or replace view Q15(EditorName, Title, PublisherName, Year, Total) as
select a2.editorname, a2.title, publisher.name, a2.year, a2.count_inproceeding
from
	publisher
right join
	(select a1.*, person.name as editorname
	from
		person
	inner join
		(select count(inproceeding.inproceedingid) as count_inproceeding, proceeding.*
		from
			proceeding
		left join
			inproceeding
		on proceeding.proceedingid = inproceeding.proceedingid
		group by proceeding.proceedingid) as a1
	on person.personid = a1.editorid) as a2
on publisher.publisherid = a2.publisherid
order by a2.count_inproceeding desc, a2. year, a2.title;

-- Q16
-- 427 rows returned

create or replace view Q16(Name) as
select name
from
	person
where personid in
	(select distinct relationpersoninproceeding.personid
	from
		relationpersoninproceeding
	left join
		(select distinct editorid
		from
			proceeding) as a1
	on relationpersoninproceeding.personid = a1.editorid
	where a1.editorid is null)
and personid in
	(select distinct a2.personid as personid
	from
		relationpersoninproceeding as a2
	inner join
		relationpersoninproceeding as a3
	on a2.inproceedingid = a3.inproceedingid
	group by a2.personid
	having count(distinct a3.personid) = 1);
	
-- Q17
-- 2955 rows returned, ordered by total number of papers in the proceeding in descending order, followed by year in ascending order, followed by title in ascending order
-- authors with no papers published in any proceeding not included

create or replace view Q17(Name, Total) as
select person.name, a1.count_proceeding
from
	person
inner join
	(select relationpersoninproceeding.personid as personid, count(distinct inproceeding.proceedingid) as count_proceeding
	from
		relationpersoninproceeding
	inner join
		inproceeding
	on relationpersoninproceeding.inproceedingid = inproceeding.inproceedingid
	group by relationpersoninproceeding.personid
	having count(distinct inproceeding.proceedingid) > 0) as a1
on person.personid = a1.personid
order by a1.count_proceeding desc, person.name;

-- Q18
-- 1 row returned
-- papers not published in any proceedings not included
-- minimum publications per author: 1
-- average publications per author: 1.3052453469 (rounded down to 1)
-- maximum publications per author: 14

create or replace view Q18(MinPub, AvgPub, MaxPub) as
select min(count_inproceeding), round(avg(count_inproceeding)), max(count_inproceeding)
from
	(select a1.personid, count(a1.inproceedingid) as count_inproceeding
	from
		(select *
		from 
			relationpersoninproceeding
		where inproceedingid in
			(select inproceedingid
			from
				inproceeding
			where proceedingid is not null)
		) as a1
	group by a1.personid) as a2;
	
-- Q19
-- 1 row returned
-- proceedings with no papers included
-- minimum publications per author: 0
-- average publications per author: 27.4375 (rounded down to 27)
-- maximum publications per author: 94

create or replace view Q19(MinPub, AvgPub, MaxPub) as 
select min(count_inproceeding), round(avg(count_inproceeding)), max(count_inproceeding)
from
	(select distinct proceeding.proceedingid as proceedingid, count(inproceeding.inproceedingid) as count_inproceeding
	from
		inproceeding
	right join
		proceeding
	on inproceeding.proceedingid = proceeding.proceedingid
	group by proceeding.proceedingid) as a1;
	
-- Q20
-- after trigger "Q20" created on update and insert operations for table "relationpersoninproceeding"
-- in function Q20(), if the person_id for new state matches the condition for rejection, an exception is raised, otherwise the new state will be returned

create or replace function Q20() returns trigger as $$
begin
	if new.personid in
		(select distinct proceeding.editorid as editorid
		from
			proceeding
		inner join
			(select inproceeding.proceedingid as proceedingid, relationpersoninproceeding.personid as personid
			from 
				inproceeding 
			inner join 
				relationpersoninproceeding
			on inproceeding.inproceedingid = relationpersoninproceeding.inproceedingid) as a1
		on proceeding.editorid = a1.personid and proceeding.proceedingid = a1.proceedingid)
	then
		if TG_OP = 'INSERT' then
			raise exception 'Insert operation failed.';
		elsif TG_OP = 'UPDATE' then
			raise exception 'Update operation failed.';
		end if;
	end if;

	return new;
end;
$$ language plpgsql;

create trigger Q20
after insert or update on relationpersoninproceeding
for each row execute procedure Q20();

-- Q21
-- after trigger "Q21" created on update and insert operations for table "proceeding"
-- in function Q21(), if the editor_id for new state matches the condition for rejection, an exception is raised, otherwise the new state will be returned

create or replace function Q21() returns trigger as $$
begin
	if new.editorid in
		(select distinct proceeding.editorid as editorid
		from
			proceeding
		inner join
			(select inproceeding.proceedingid as proceedingid, relationpersoninproceeding.personid as personid
			from 
				inproceeding 
			inner join 
				relationpersoninproceeding
			on inproceeding.inproceedingid = relationpersoninproceeding.inproceedingid) as a1
		on proceeding.editorid = a1.personid and proceeding.proceedingid = a1.proceedingid)
	then
		if TG_OP = 'INSERT' then
			raise exception 'Insert operation failed.';
		elsif TG_OP = 'UPDATE' then
			raise exception 'Update operation failed.';
		end if;
	end if;

	return new;
end;
$$ language plpgsql;

create trigger Q21
after insert or update on proceeding
for each row execute procedure Q21();

-- Q22
-- after trigger "Q22" created on update and insert operations for table "inproceeding"
-- in function Q22(), if the proceeding_id for new state matches the condition for rejection, an exception is raised, otherwise the new state will be returned

create or replace function Q22() returns trigger as $$
begin
	if new.proceedingid in
		(select distinct proceeding.proceedingid as proceedingid
		from
			proceeding
		inner join
			(select inproceeding.proceedingid as proceedingid, relationpersoninproceeding.personid as personid
			from 
				inproceeding 
			inner join 
				relationpersoninproceeding
			on inproceeding.inproceedingid = relationpersoninproceeding.inproceedingid) as a1
		on proceeding.editorid = a1.personid and proceeding.proceedingid = a1.proceedingid)
	then
		if TG_OP = 'INSERT' then
			raise exception 'Insert operation failed.';
		elsif TG_OP = 'UPDATE' then
			raise exception 'Update operation failed.';
		end if;
	end if;

	return new;
end;
$$ language plpgsql;

create trigger Q22
after insert or update on inproceeding
for each row execute procedure Q22();