[![CircleCI](https://circleci.com/gh/GSA/catalog-solr.svg?style=svg)](https://circleci.com/gh/GSA/catalog-solr)

# catalog-solr

Provides a CKAN-compatible Solr instance for local development. See
[catalog-app](https://github.com/GSA/catalog-app) as an example.

Solr configsets are provided for each version of CKAN. At runtime, your CKAN
instance can create a new Solr core based on the version of CKAN in use. This
allows us to produce a single image that can be used by multiple instances of
CKAN across multiple versions of CKAN.


## Usage

At CKAN startup, you'll want to create the Solr core.

For example, to create core named `myckan` for version 2.5:

```
curl -v --get --fail --silent http://solr:8983/solr/admin/cores \
  --data-urlencode action=create \
  --data-urlencode name=myckan \
  --data-urlencode configSet=ckan2_5
```

You can put this in an init/startup script before starting CKAN. To make sure
you don't try to create a Solr core that has already been created, you can check
if it exists using the core status API.

```
# Check if the solr core exists
if ! (curl --get --fail --silent http://solr:8983/solr/admin/cores \
  --data-urlencode action=status \
  --data-urlencode core=ckan | grep -q segmentsFileSizeInBytes); then

  # Create the solr core
  curl -v --get --fail --silent http://solr:8983/solr/admin/cores \
    --data-urlencode action=create \
    --data-urlencode name=ckan \
    --data-urlencode configSet=ckan2_5
fi
```


## Development

Build the solr container.

    $ docker-compose build solr

Run the tests.

    $ make clean test

_Note: the tests mutate state in the solr container and don't cleanup this state
between runs. You can clean this state with `make clean`, or by re-creating the
solr container._
