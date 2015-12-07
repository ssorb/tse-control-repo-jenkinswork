# Change Log

## Unreleased

Improvements:

  - Updated lwf/remote\_file to newest release, 1.1.0
  - Do not continuously enforce node\_groups. Only apply node\_groups once,
    during provisioning. This de-couples the Console from the code, so that
    changes users make in the console are not overriden when Puppet runs.
  - Add locp/cassandra module from the Forge and parameterize the cluster\_name
    of the cassandra profile.
  - Move the git source of the puppetlabs/firewall module back to the Puppet
    Labs github repo. (We are able to do this now that a necessary patch has
    been merged).

## 2015.2.3-1 (2015-11-13)

(this space intentionally left blank)

---

# Legend

This is a suggested format for Changelog. Not every catagory need be filled in for every release.

## tag (release date)

Features:

  - Notable new functionality
  - Does not necessarily have a 1:1 correspondence with commits

Bugfixes:

  - Commits made that fix things previously broken or bugged
  - Typically things that would be considered z-level fixes in Semantic Versioning

Improvements:

  - Changes made to streamline performance or clean up technical debt
  - Changes made to better align our code or layout with Professional Services
    or best practices
  - Betterment work which is not strictly a feature or a bugfix

Workarounds:

  - Things we've done that aren't permanent, but which allow us to advance
    features or bugfixes where we otherwise couldn't.
  - Oftentimes this might be something like using a git checkout for a module
    while we wait for a release to be cut with a needed fix or feature
  - It is expected that most workarounds will eventually be replaced by an
    improvement.
