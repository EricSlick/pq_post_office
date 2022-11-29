# Public APIs

## Outgoing
APIs that reach out to third party services. I find it easier to identify
the right API if they are broken down this way. API's will be versioned and 
each api type will have its own folder structure.

These APIs have the following layers (conceptually or physically)
1. Internal Facing API
   1. App 'talks' to this API
   2. Provides a common interface and isolates third party code from the App
   3. Can be combined with the Manager depending on complexity and needs
2. Manager
   1. Manages connections to the third party adapters
   2. Adapters 'register' their availability to the manager.
   3. Load balancing can be part of the manager on complexity and needs. 
3. Load Balancer/s
   1. Strategy or strategies for calling out to multiple adapters
   2. Can be part of the manager depending on complexity and needs
4. Adapters
   1. One adapter per third party which provides common services to the internal
      facing API  
   2. Implements the connection to the third party service
   3. Implements the Manager's expected methods
   4. Transforms the third party data structure to the expectations of the
      internal facing API and/or Manager's expected structure
   5. implements third party callbacks

**Implementation Notes**
* Synchronous
  * All calls into the API do not return until they get a response from the third party/ies
* Asynchronous Opportunities
  * Third party response asynchronously
  * Jobs trigger requests
    * valuable if the third party responds synchronously
    * simpler than threads

## Incoming
APIs that service third party services that call into this application.

