import tarantool

host = "127.0.0.1"
port = 3301
user = 'admin'
password = 'secret-cluster-cookie'

number_of_buckets = 2000
bucket_size = 20


def connect(host, port, user, password):
    return tarantool.connect(host, port, user, password)


def get(conn, space, pk, opts):
    return conn.call('crud.get', (space, pk, opts))[0]


def insert_object(conn, space, object, opts):
    return conn.call('crud.insert_object', (space, object, opts))


def replace_object(conn, space, object, opts):
    return conn.call('crud.replace_object', (space, object, opts))


def delete(conn, space, pk, opts):
    return conn.call('crud.delete', (space, pk, opts))


def disconnect(conn):
    return conn.close()


def unflatten(data):
    if data:
        if data['rows'] and data['metadata']:
            flatten = []
            for _, row in enumerate(data['rows']):
                tuple = dict()
                for field_num, field in enumerate(row):
                    tuple[data['metadata'][field_num]['name']] = field
                flatten.append(tuple)
            return flatten


conn = connect(host, port, user, password)


def add_entity(id):
    print('Insert object:\n',
          unflatten(
              insert_object(
                  conn,  # connection
                  'entity',  # space name
                  dict(
                      entity_id=id,
                      entity_name='entity_'+str(id),
                      entity_description='No description for entity '+str(id)
                  ),  # object
                  {}  # options
              )[0]
          )
          )


def delete_entity(id):
    print('Delete object\n', unflatten(delete(conn, 'entity', id, {})[0]))


for i in range(1, bucket_size+1):
    add_entity(i)

for i in range(1, number_of_buckets+1):
    for j in range(i*bucket_size+1, i*bucket_size+bucket_size+1):
        add_entity(j)
        delete_entity(j-bucket_size)

for i in range(number_of_buckets*bucket_size+1, number_of_buckets*bucket_size+bucket_size+1):
    delete_entity(i)

disconnect(conn)
