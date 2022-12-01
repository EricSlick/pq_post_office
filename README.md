# ParentSquare PostOffice
This is a take home tech interview. The purpose is to build an application that manages
the receiving of messages and sending of those messages to one of two third party services 
that are responsible for sending those messages to end users.

## Tech Stack

* Ruby 3.1.2
* Postgres
* Tailwind
* Turbo/Stimulus
* Postgres
* Redis
* Sidekiq

## Setup

    bundle
    rails db:create
    rails db:migrate

## Run Tests
    rspec

## Run Server
    rails s
    https://localhost:3000

* Deployment instructions
  * Deployed on Render
  * Auto deploy on branch main update

## Development Log

I'm not rushing this take home test and am trying out some tech that's new to me. 
I've never used Render before or Tailwind. I am only lightly familiar with Turbo/Stimulus. 
I started with the unfamiliar to get it right before moving to the familiar.

**11/28/2022**
* Time: 2 hours
* Initial Rails App created
* Working out deploy to Render

**11/29 & 11/30 2022**
* Time: 2 hours
* API initial layout
* Investigate Tailwind CSS and initial Views
* Initial Message Model

**12/1
* Time:
* Improved Message model to have a uuid column
  * overkill for this project but this allows for easier portability of data between databases such as for distributed databases that need to have their data balanced between dbs
  * left id as the identity column but if this level of portability isn't needed, the id could have been a uuid.
* Formal(ish) Proposal and other readme additions
* Model creation and indexing with specs


# Formal(ish) Proposal
note: Doing this in the README as a convenience. It is abbreviated due to the nature of this project. 
A more formal proposal would include more detail about alternatives, any spikes and their result, etc.

## Technology Stack

**Chosen**
* Rails 7
* Ruby 3.1.2
* Postgres
* Tailwind
* Turbo/Stimulus
* Postgres
* Redis
* Sidekiq

### Rails 7
New projects typically will be started with the latest Rails version. For this test 
there is no reason to use a previous version, but the reasons not to use the 
latest is stability. Rails 7 is enough minor versions in that is can be considered stable.

### Ruby 3.1.2
Like the choice of the latest Rails version, the same applies to which Ruby to use. In 
this case, the version is available on Render and so it's being used. However, reasons not 
to use any version typically revolves around two things: gem compatibility and availability 
of the ruby version on the deploy target OS. For production, the linux version of the servers
you are using might not have the latest version of ruby as part of their stable releases.

# Postgres
Postgres is what I'm most familiar with and seems to be the most popular DB to use. MySQL is 
a fine choice too, but MySQL does have it's strengths (none of which I recall and won't be spending
the time to research). 
Since this project has a very limited database model, and that model is simple, a no-sql 
database doesn't fit the needs of this project except for using Redis with Sidekiq.

# Tailwind
This was made because after a quick bit of research, I settled on this due to its seeming 
popularity and my desire to try something new and fresh. It also seemed to fit my past experience 
well and I felt I understood it better than other more modern css solutions. I'm not an expert
in this area, so this was definitely not comprehensive.  

# Turbo/Stimulus
I've done a small project recently trying out Turbo/Stimulus that could act as my 'spike'. I
chose this as it's native to Rails 7, it makes doing reactive UI's far simpler than other 
UI frameworks, such as React, Vue, etc. It fits my past experiences well and this project 
is very simple and is not going to have millions of users. I want to better learn turbo/stimulus 
and I believe it will let me do some nice improvements to the UI with little extra effort.

# Sidekiq / Redis
I'm very familiar with Sidekiq and that drives my choice here. I could have used the built-in
ActiveJobs, but as Sidekiq is a de-facto standard that is widely supported. I plan to use it to 
add some asynchronous behavior to the process of receiving and/or sending messages.

## Architecture
For this, the architecture encompasses the receiving, sending and display of messages. Sending and
receiving will be done via internal and public apis

## API Structure
While this project isn't particularly big, I wanted to break out the API in the way I like as if it
will have or has multiple APIs. This lets me shows how a more complicated API structure could be 
configured to allow separation of responsibilities.

At Snapdocs, they had many APIs that were mostly cluttered together. It made locating the right
API and the code for it more difficult than it should be. As all startups, their code base grew
organically and while there was good choices being made, I think this structure could have made 
it easier to support. This structure is still new to me and I'm sure it can be improved upon or 
even simplified and still achieve the same results.

This project has two basic divisions of APIs: Internal, and Public.  Internal APIs are APIs only
used by the company's internal echo system of apps and services. Public APIs are where 
third party apps/services can pass requests into this app. Also, it's where the app will
call out to third party services.

Both Internal and Public folders then have the same pair of folders within them: 
incoming and outgoing. Incoming APIs are for requests sent to the app and Outgoing are
for calling outside the app for data.

Inside each of the Internal and Public folders are folders for each API. Within those
folders would be the version folders.

Again, this is assuming there are more than just a few APIs.

**Folder Structure**

- internal
  - incoming
    - api_one_in
      - v1
      - ...
    - ...
  - outgoing
    - api_one_out
      - v1
      - ...
    - ...
- public
  - incoming
    - api_one_in
      - v1
      - ...
    - ...
  - outgoing
    - api_one_out
      - v1
      - ...
    - ...
  

### Restful, vs Protobuf vs Pub/Sub
Since the outgoing APIs are already restful, that's what I'm using for my incoming api (messages received).

Other options could be Google protobuf for synchronous calls or a Pub/Sub solution for
asynchronous calls. Pub/Sub works well for internal APIs as it simplifies the APIs into a 
single API that uses JSON to describe the action along with the data. Pub/Sub is a good solution
for his approach. However, reaching out to third parties for data requires implementing their
own API solution

## Isolating Third Party Services
Again, for this app, what I'm doing is overkill, but it still benefits from this approach.

The classic problem with implementing any third party services is that it tends to get entangled
with the app's code and if it should be decided to switch to a new service for this data it can
be very difficult to make that switch.

The solution is to isolate the third party code to make it easier to replace. Ideally, third 
party solutions would create the integration of their services with ours. We'd have a single
interface we want to use and they have to do the work in making us happy.

Of course, this isn't going to happen, but we can conceptually make this happen on
our side. To do this we need to isolate the application from how it gets data from
the third party services. This consists of an internally facing API used only 
by the application itself. This calls a manager class that handles two main things: 
load balancing and which third party adapter to dall, the third layer is the 
third party adapter layer. This is where all the code resides for communicating
with the third party. Conceptually, I think of these as layers where each layer
has a hard wall between them where they only interact via an agreed-upon interfacxe.

### Internally Facing API Layer
This is a single class that implements the API in the way that is most advantageous
to the application. This includes the the way the data is passed into this API and the
data structure the app wants from incoming data. The application code only calls this
internally facing API. It knows nothing about third party services or how they are handled.
It does know which manager to call.

### Manager Layer
The manager sits in-between the Internally Facing API and the Adapters that implement the
third party services. This is responsible for calling the right adapter and handling any 
load balancing.

The manager bridges the Internal Facing API to the Adapter/s. I like to have all three layers
implement the internally facing API. It doesn't have to be this way, but it helps avoid having
the manager class have to translate between class interfaces and it simplifies identifying the 
connection between the three layers.

### Adapter Layer
This is the only code that knows how to connect to a third party service and retrieve the desired
data. It implements the Internally Facing API (as called from the manager), and it is responsible
for translating the data received from the third party into the data format expected by the
internally facing API interface.

### Advantages Of This Approach
Any updates to third party APIs can be handled by an update to the adapter. The adapter can be
versioned easily and as long as it implements the internally facing API (or the manager's interface
if it was different).

Switching to a new third party service is easy. As long as it implements the internally facing API
it will just work. 

Updating any one of the layers doesn't affect any of the others except in the case of changes to
the internally facing API. None of the layers know anything about the other layers except how to call
them.

This pattern can be adapted based on the complexity, with the simplest solution being a single class
for each layer. For more complex solutions, there might be multiple internal APIs that call multiple 
managers. A single manager could fan out into different managers that manage a common group of third party
services. Multiple load balancing schemes could be broken into multiple classes, etc.

It is relatively easy to reason where code is within the app which also makes it easier to debug side effects.
The chances of having side effects is reduced as well due to the code being strictly divided by 
responsibility.

### Disadvantages Of This Approach
It is added complexity and not every application needs this.

### Other Use Cases 
This pattern is useful for isolating gems as well as third party apis. Sometimes a gem is great
but it may stop being supported, a better option comes along or a new, cooler version of it is released.
By isolating gems this way, you can be better prepared for these eventualities.

You can isolate internal services using this pattern which allows easier handling of version
changes, refactorings and even replacing those services. 

Finally, you can approach the internal features of an application by isolating such features or 
groups of features. There are other ways to achieve this, such as through rails engines or just 
creating intentional divisions in the code that encourage isolation.

## Database Architecture
This is simple. There's a message. It has a phone number and a message body. I needs to track
what state it is in (received, sent, delivered). Only one model is needed to track this.

**Messages Table**
  * uuid (demonstrates how to achieve portability between databases)
  * status (received, sent, delivered)
  * phone
  * body

**indexes**
* uuid
* status
* phone