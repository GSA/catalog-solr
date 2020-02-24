FROM solr:5.5

COPY solrconfig.xml /opt/solr/server/solr/configsets/basic_configs/conf/

# Create configsets for CKAN versions
RUN \
    mkdir -p /opt/solr/server/solr/configsets/ckan2_8 ; \
    cp -r /opt/solr/server/solr/configsets/basic_configs/conf/ /opt/solr/server/solr/configsets/ckan2_8/ ;

# Copy schema
COPY schema2_8.xml /opt/solr/server/solr/configsets/ckan2_8/conf/schema.xml

# Create cores for catalog (ckan2_3) and inventory (ckan2_5) as one image,
# compatible for both versions of CKAN. This gives us most flexibility for
# having an image that can be dropped in, ready to go or create the cores on
# initialization.
RUN \
    mkdir -p /opt/solr/server/solr/ckan2_8/data; \
    cp -r /opt/solr/server/solr/configsets/ckan2_8/conf /opt/solr/server/solr/ckan2_8/conf; \
    echo name=ckan2_8 > /opt/solr/server/solr/ckan2_8/core.properties;
