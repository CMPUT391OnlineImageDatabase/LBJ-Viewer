CREATE TABLE imagescount (
	image_id int,
	counter int,
	FOREIGN KEY(image_id) REFERENCES images
);
CREATE TABLE imagesviewer (
	image_id int,
	people_viewed varchar(24),
	FOREIGN KEY(image_id) REFERENCES images,
	FOREIGN KEY(people_viewed) REFERENCES users
);
