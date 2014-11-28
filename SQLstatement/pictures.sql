Drop TABLE pictures;
Drop SEQUENCE pic_id_sequence;

CREATE TABLE pictures (
	pic_id int,
	pic_desc varchar(100),
	pic BLOB,
	primary key(pic_id)
);


CREATE SEQUENCE pic_id_sequence;
