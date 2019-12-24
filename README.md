## Assignment-1

Details on the kinds of data items that might need to be stored in the back-end of the myPhotos.net web site:

### Photos
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

### Photo Collections
* a photo collection is simply a group of photos
* each collection has an owner (a user), a title and some descriptive text
* a collection may include photos from any user, as long as they are public
* photos within a collection appear in an order defined by the owner
* one photo is defined to be a "key photo" for the collection and is displayed
* whenever the collection appears in a list of collections (along with the title)

### People
* for every person associated with the site, we need to know at least their email address and their name
* we also store separate family and given names, for sorting lists of people
* everyone must have at least one given name, but some people may have no family name (e.g. Prince)

### Users
* users are people who can log in to the site and upload pictures
* each user needs to be registered with the system and must provide an email address and a password
* their email and password are used for authentication when they log in to the system
* we record the date when each user joins the site (registration date)
* logging in takes them to their home-page, which displays a list of their photo collections
* once logged in, they can modify information related to themselves via their "Account" page
* users may provide additional information about themselves, including their personal website, their gender and their birthday
* they can also upload a small image of themselves (JPEG, smaller than 64KB)
* users can also create contact lists for people they might want to inform about their photos

### Contacts
* a contact is a person outside the system who is associated with a user
* all that we really need to know about a contact is their name and their email address

### Groups
* users can form groups (e.g. special interest groups) consisting of a set of users
* each group is created and managed by some user (its owner)
* a group can be set up in a number of modes: private, by-invitation, by-request
* private groups are managed by a user and might be "Friends", "Family", etc.
* by-invitation groups allow the owner to invite people to join
* by-request groups allows users to ask to be added to a group
* private and by-invitation groups are not visible when users search/browse groups
* each group has a title, a set of photo collections, and a list of discussion threads (a discussion thread is simply a title and a list of messages)

### Tags
* photos can be tagged by short phrases like "landscape", "street life", etc.
* tags are used as a mechanism for finding groups of similar photos (they could also be viewed as defining informal collections)
* when a user is tagging a photo, auto-completion will be used to suggest tags, to try to ensure consistent usage

### Comments
* a comment is a small piece of text written by a user
* comments can be threaded (by one comment referring to an earlier comment)
* for each comment, we need to record the author and the time it was posted
