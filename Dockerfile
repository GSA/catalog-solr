FROM solr:5.5

COPY solrconfig.xml /opt/solr/server/solr/configsets/basic_configs/conf/

# Create configsets for CKAN versions
RUN \
  for ckan_version in ckan2_3 ckan2_5; do \
    mkdir -p /opt/solr/server/solr/configsets/$ckan_version ; \
    cp -r /opt/solr/server/solr/configsets/basic_configs/conf/ /opt/solr/server/solr/configsets/$ckan_version/ ; \
  done

# Copy schema
COPY schema2_3.xml /opt/solr/server/solr/configsets/ckan2_3/conf/schema.xml
COPY schema2_5.xml /opt/solr/server/solr/configsets/ckan2_5/conf/schema.xml

# Create cores for catalog (ckan2_3) and inventory (ckan2_5) as one image,
# compatible for both versions of CKAN. This gives us most flexibility for
# having an image that can be dropped in, ready to go or create the cores on
# initialization.
RUN \
  for ckan_version in ckan2_3 ckan2_5; do \
    mkdir -p /opt/solr/server/solr/$ckan_version/data; \
    cp -r /opt/solr/server/solr/configsets/$ckan_version/conf /opt/solr/server/solr/$ckan_version/conf; \
    echo name=$ckan_version > /opt/solr/server/solr/$ckan_version/core.properties; \
  done
