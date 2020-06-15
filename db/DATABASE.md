# Database
### Notification

| Column            | Type      | Detail                | Version       |
| ----------------- |:---------:|:---------------------:| -------------:|
| id                | integer   | NOT NULL              | Init          |
| contact_number    | varchar   | NOT NULL              | Init          |    
| device_token      | varchar   | NOT NULL              | Init          |
| device_platform   | varchar   | NOT NULL              | Init          |
| is_retrieved      | boolean   |                       | Init          |
| is_activated      | boolean   |                       | Init          |
| activated at      | timestamp |                       | Init          |
| container_id      | integer   | Reference(Container)  | Init          |
| created_at        | timestamp |                       | Init          |
| updated_at        | timestamp |                       | Init          |
| hbl_id            | integer   | Reference(HBL)        | 2             |

### Notification Items

| Column            | Type      | Detail                                    | Version       |
| ----------------- |:---------:|:-----------------------------------------:| -------------:|
| id                | integer   | NOT NULL                                  | Init          |
| container_number  | varchar   | Can be empty if hbl_uid exist             | Init          |
| message           | varchar   | Needed for Push Notification              | Init          |
| device_id         | integer   | NOT NULL                                  | Init          |
| created_at        | timestamp |                                           | Init          |
| updated_at        | timestamp |                                           | Init          |
| is_new            | boolean   |                                           | Init          |
| title             | varchar   | Needed for Push Notification              | Init          |
| colour            | varchar   |                                           | Init          |
| hbl_uid           | varchar   | Can be empty if container_number exist    | 2             |

### Notification Jobs

| Column        | Type      | Detail                        | Version   |
| ------------- |:---------:|:-----------------------------:| ---------:|
| id            | integer   | NOT NULL                      | Init      |
| title         | varchar   | Needed for Push Notification  | Init      |
| message       | varchar   | Needed for Push Notification  | Init      |
| is_sent       | bool      |                               | Init      |
| send_at       | timestamp |                               | Init      |
| container_id  | integer   | Reference(Container)          | Init      |
| created_at    | timestamp |                               | Init      |
| updated_at    | timestamp |                               | Init      |
| status_output | varchar   |                               | Init      |
| hbl_id        | integer   | Reference(HBL)                | 2         |

### HBL
| Column            | Type          | Detail                    | Version   |
| ----------------- |:-------------:|:----------:| -------------------------------:|
| id                | integer       | NOT NULL                  | Init      |
| inventory_id      | varchar       | Needed as differentiate   | Init      |
| hbl_uid           | varchar       | Needed as differentiate   | Init      |
| sequence_no       | varchar       | Needed                    | Init      |
| sequence_prefix   | varchar       |                           | Init      |
| pod               | varchar       |                           | Init      |
| mquantity         | varchar       |                           | Init      |
| mtype             | varchar       |                           | Init      |
| mvolume           | varchar       |                           | Init      |
| mweight           | varchar       |                           | Init      |
| container_id      | integer       | Reference(Container)      | Init      |
| created_at        | timestamp     |                           | Init      |
| updated_at        | timestamp     |                           | Init      |
| markings          | varchar       |                           | Init      |
| length            | varchar       |                           | Init      |
| breadth           | varchar       |                           | Init      |
| height            | varchar       |                           | Init      |
| remarks           | varchar       |                           | Init      |