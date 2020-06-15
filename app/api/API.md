## API for backend (CRUD data from backend to production server)
### Add Container data (POST)
[url]/api/v1/container_data </br></br>
| Column            | Type          | Detail     | Example Data        |
| ----------------- |:-------------:|:----------:| -------------------:|
| container_id      | string        | Not Null   |                     |
| container_prefix  | string        | Not Null   |                     |
| container_number  | string        | Not Null   |                     |
| schedule_date     | string        | Optional   |                     |
| unstuff_date      | string        | Optional   |                     |
| last_day          | timestamp     | Optional   | 2020-03-20 06:50:30 |
| f5_unstuff_date   | date          | Optional   | 2020-03-22          |
| f5_last_day       | timestamp     | Optional   | 2020-03-20 06:50:30 |
| location          | string        | Optional   |                     |
| eta               | timestamp     | Optional   | 2020-03-20 06:50:30 |
| cod               | timestamp     | Optional   | 2020-03-20 06:50:30 |


### Add HBL data (POST)
[url]/api/v1/container_data/hbl </br>
| Column            | Type          | Detail     | Example Data                    |
| ----------------- |:-------------:|:----------:| -------------------------------:|
| container_id      | string        | Not Null   | Use container number (0707280)  |
| inventory_id      | string        | Not Null   |                                 |
| hbl_uid           | string        | Not Null   |                                 |
| sequence_no       | string        | Not Null   |                                 |
| sequence_prefix   | string        | Optional   |                                 |
| pod               | string        | Optional   |                                 |
| mquantity         | string        | Optional   |                                 |
| mtype             | string        | Optional   |                                 |
| mvolume           | string        | Optional   |                                 |
| mweight           | string        | Optional   |                                 |
| markings          | string        | Optional   |                                 |
| length            | string        | Optional   |                                 |
| breadth           | string        | Optional   |                                 |
| height            | string        | Optional   |                                 |
| remarks           | string        | Optional   |                                 |