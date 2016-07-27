CREATE TABLE files
(
    name TEXT,
    sha1 TEXT,
    cdate TEXT,
    size INTEGER
);
CREATE UNIQUE INDEX files_name_uindex ON files (name);

