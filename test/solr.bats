#!/usr/bin/env bats

function setup () {
  # Wait 5 seconds for solr to be up
  retries_remaining=5
  while ! nc -z -w 5 solr 8983; do
    if [[ $retries_remaining -le 0 ]]; then
       echo error: gave up waiting for solr to be available >&2
       return 1
    fi

    retries_remaining=$(( $retries_remaining - 1 ))
    sleep 1
  done
}

@test "solr is up" {
  curl -v --fail --silent http://solr:8983/solr
}

@test "can create ckan2_3 core" {
  curl -v --get --fail --silent http://solr:8983/solr/admin/cores \
    --data-urlencode action=create \
    --data-urlencode name=ckan23 \
    --data-urlencode configSet=ckan2_3
}

@test "check status of ckan2_3 core" {
  run curl --get --fail --silent http://solr:8983/solr/admin/cores \
    --data-urlencode action=status \
    --data-urlencode core=ckan23

  [ "$status" -eq 0 ]
  echo "$output" | grep -q segmentsFileSizeInBytes
}

@test "can create ckan2_5 core" {
  curl -v --get --fail --silent http://solr:8983/solr/admin/cores \
    --data-urlencode action=create \
    --data-urlencode name=ckan25 \
    --data-urlencode configSet=ckan2_5
}

@test "check status of ckan2_5 core" {
  run curl --get --fail --silent http://solr:8983/solr/admin/cores \
    --data-urlencode action=status \
    --data-urlencode core=ckan25

  [ "$status" -eq 0 ]
  echo "$output" | grep -q segmentsFileSizeInBytes
}
