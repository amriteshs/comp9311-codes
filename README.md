## Assignment-1

Details on the kinds of data items that might need to be stored in the back-end of the myPhotos.net web site:

#### Photos
* photos can be uploaded onto the site and must be in JPEG format
* each photo is stored in the file system and a record about the photo is created
* the photo record contains a title for the picture, descriptive text and the file size in KB
* the photo record also contains the date when the photo was taken and when it was uploaded
* there is also scope for an optional description of the technical details of the photo (e.g. what kind of camera, lens, exposure settings, etc.)
* the system often displays thumbnails of photos (e.g. in photo lists); each photo has a thumbnail, also stored on the filesystem, created when the photo is uploaded
* users can make comments on photos (see Comments below)
* users can also rate photos (on a 1-5 star scale; 1=ordinary, 5=exceptional)
* each photo must be assigned a "safety-level" when it is uploaded; possible settings are: Safe (suitable for children), Moderate (not suitable for children), Restricted (R-rated) 
* the owner of a photo can also set its visibility; possible settings are Private, Friends, Family, Friends+Family, Public

#### Photo Collections
* a photo collection is simply a group of photos
* each collection has an owner (a user), a title and some descriptive text
* a collection may include photos from any user, as long as they are public
* photos within a collection appear in an order defined by the owner
* one photo is defined to be a "key photo" for the collection and is displayed
* whenever the collection appears in a list of collections (along with the title)

#### People
* for every person associated with the site, we need to know at least their email address and their name
* we also store separate family and given names, for sorting lists of people
* everyone must have at least one given name, but some people may have no family name (e.g. Prince)

#### Users
* users are people who can log in to the site and upload pictures
* each user needs to be registered with the system and must provide an email address and a password
* their email and password are used for authentication when they log in to the system
* we record the date when each user joins the site (registration date)
* logging in takes them to their home-page, which displays a list of their photo collections
* once logged in, they can modify information related to themselves via their "Account" page
* users may provide additional information about themselves, including their personal website, their gender and their birthday
* they can also upload a small image of themselves (JPEG, smaller than 64KB)
* users can also create contact lists for people they might want to inform about their photos

#### Contacts
* a contact is a person outside the system who is associated with a user
* all that we really need to know about a contact is their name and their email address

#### Groups
* users can form groups (e.g. special interest groups) consisting of a set of users
* each group is created and managed by some user (its owner)
* a group can be set up in a number of modes: private, by-invitation, by-request
* private groups are managed by a user and might be "Friends", "Family", etc.
* by-invitation groups allow the owner to invite people to join
* by-request groups allows users to ask to be added to a group
* private and by-invitation groups are not visible when users search/browse groups
* each group has a title, a set of photo collections, and a list of discussion threads (a discussion thread is simply a title and a list of messages)

#### Tags
* photos can be tagged by short phrases like "landscape", "street life", etc.
* tags are used as a mechanism for finding groups of similar photos (they could also be viewed as defining informal collections)
* when a user is tagging a photo, auto-completion will be used to suggest tags, to try to ensure consistent usage

#### Comments
* a comment is a small piece of text written by a user
* comments can be threaded (by one comment referring to an earlier comment)
* for each comment, we need to record the author and the time it was posted


## Assignment-2

In this assignment, the schema for a simple publication database is provided to you. The file is: pub-schema.sql. Based on the provided schema, you are required to answer the following questions by formulating SQL queries. You may create SQL functions or PLpgSQL to help you, if and only if the standard SQL query language is not expressive and powerful enough to satisfy a particular question. To enable auto-marking, your queries should be formulated as SQL views, using the view names and attribute names provided. Since this assignment is auto-marked, using different view names and/or attribute names from the provided names may result in losing part or all of the marks for the questions involved. If any answer requires you to output a calculated value that has decimals, you should round it to an integer.

1. List all the editors.
    create or replace view Q1(Name) as ...

2. List all the editors that have authored a paper.
    create or replace view Q2(Name) as ...

3. List all the editors that have authored a paper in the proceeding that they have edited.
    create or replace view Q3(Name) as ...

4. For all editors that have authored a paper in a proceeding that they have edited, list the title of those papers.
    create or replace view Q4(Title) as ...

5. Find the title of all papers authored by an author with last name "Clark".
    create or replace view Q5(Title) as ...

6. List the total number of papers published in each year, ordered by year in ascending order. Do not include papers with an unknown year of publication. Also do not include years with no publication.
    create or replace view Q6(Year, Total) as ...

7. Find the most common publisher(s) (the name). (i.e., the publisher that has published the maximum total number of papers in the database).
    create or replace view Q7(Name) as ...

8. Find the author(s) that co-authors the most papers (output the name). If there is more than one author with the same maximum number of co-authorships, output all of them.
    create or replace view Q8(Name) as ...

9. Find all the author names that never co-author (i.e., always published a paper as a sole author).
    create or replace view Q9(Name) as ...

10. For each author, list their total number of co-authors, ordered by the total number of co-authors in descending order, followed by author names in ascending order. For authors that never co-author, their total is 0. For example, assume John has written 2 papers so far: one with Jane, Peter; and one with Jane, David. Then the total number of co-authors for John is 3. In other words, it is the number of people that have written papers with John.
    create or replace view Q10(Name, Total) as ...

11. Find all the author names that have never co-authored with any co-author of Richard (i.e. Richard is the author's first name), nor co-authored with Richard himself.
    create or replace view Q11(Name) as ...

12. Output all the authors that have co-authored with or are indirectly linked to Richard (i.e. Richard is the author's first name). We define that a is indirectly linked to b if there exists a C p1, p1 C p2,..., pn C b, where x C y means x is co-authored with y.
    create or replace view Q12(Name) as ...

13. Output the authors name, their total number of publications, the first year they published, and the last year they published. Your output should be ordered by the total number of publications in descending order and then by name in ascending order. If none of their publications have year information, the word "unknown" should be output for both first and last years of their publications.
    create or replace view Q13(Author, Total, FirstYear, LastYear) as ...

14. Suppose that all papers that are in the database research area either contain the word or substring "data" (case insensitive) in their title or in a proceeding that contains the word or substring "data". Find the number of authors that are in the database research area. (We only count the number of authors and will not include an editor that has never published a paper in the database research area).
    create or replace view Q14(Total) as ...

15. Output the following information for all proceedings: editor name, title, publisher name, year, total number of papers in the proceeding. Your output should be ordered by the total number of papers in the proceeding in descending order, then by the year in ascending order, then by the title in ascending order.
    create or replace view Q15(EditorName, Title, PublisherName, Year, Total) as ...

16. Output the author names that have never co-authored (i.e., always published a paper as a sole author) nor edited a proceeding.
    create or replace view Q16(Name) as ...

17. Output the author name, and the total number of proceedings in which the author has at least one paper published, ordered by the total number of proceedings in descending order, and then by the author name in ascending order.
```create or replace view Q17(Name, Total) as ...```

18. Count the number of publications per author and output the minimum, average and maximum count per author for the database. Do not include papers that are not published in any proceedings.
```create or replace view Q18(MinPub, AvgPub, MaxPub) as ...```

19. Count the number of publications per proceeding and output the minimum, average and maximum count per proceeding for the database.
```create or replace view Q19(MinPub, AvgPub, MaxPub) as ...```

20. Create a trigger on RelationPersonInProceeding, to check and disallow any insert or update of a paper in the RelationPersonInProceeding table from an author that is also the editor of the proceeding in which the paper has published.

21. Create a trigger on Proceeding to check and disallow any insert or update of a proceeding in the Proceeding table with an editor that is also the author of at least one of the papers in the proceeding.

22. Create a trigger on InProceeding to check and disallow any insert or update of a proceeding in the InProceeding table with an editor of the proceeding that is also the author of at least one of the papers in the proceeding.
