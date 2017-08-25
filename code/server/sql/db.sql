SET NAMES 'utf8';
DROP DATABASE IF EXISTS fulla;
CREATE DATABASE fulla CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE fulla;

CREATE TABLE artikel (
    id INTEGER NOT NULL AUTO_INCREMENT,
    bezeichnung VARCHAR(255) NOT NULL,
    bestand INTEGER NOT NULL,
    preis DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE kunde (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    kreditkarte VARCHAR(16),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE kauf (
    id INTEGER NOT NULL AUTO_INCREMENT,
    id_kunde INTEGER NOT NULL,
    id_artikel INTEGER NOT NULL,
    menge INTEGER NOT NULL,
    zeitpunkt DATETIME NOT NULL,
    FOREIGN KEY (id_kunde) REFERENCES kunde(id),
    FOREIGN KEY (id_artikel) REFERENCES artikel(id),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE user (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    berechtigung BOOLEAN NOT NULL,
    pw_algo VARCHAR(255) NOT NULL,
    algo_param INTEGER NOT NULL,
    pw_hash VARCHAR(255) NOT NULL,
    pw_salt VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO artikel (bezeichnung, bestand, preis) VALUES ( 'Mistgabel XXL', 763, 60.50);
INSERT INTO artikel (bezeichnung, bestand, preis) VALUES ( 'Bürolampe', 49, 49.90);
INSERT INTO artikel (bezeichnung, bestand, preis) VALUES ( 'Koenigsegg CCXR Trevita', 1, 4800000.00);
INSERT INTO artikel (bezeichnung, bestand, preis) VALUES ( 'Grafikkarte MEGABOOST', 99, 499.95);

INSERT INTO kunde (name, kreditkarte) VALUES ('Marleen Geyer', '4539776130533364');
INSERT INTO kunde (name, kreditkarte) VALUES ('Andre Theis', '5201547717047688');
INSERT INTO kunde (name, kreditkarte) VALUES ('Hans-Ludwig Vogler', '4532893243400881');
INSERT INTO kunde (name, kreditkarte) VALUES ('Richard Harder', '6011963274213845');
INSERT INTO kunde (name, kreditkarte) VALUES ('Angelina Frenzel', '4929908008308342');
INSERT INTO kunde (name, kreditkarte) VALUES ('Walli Renz', '5529850691331291');
INSERT INTO kunde (name, kreditkarte) VALUES ('Dana Lehmann', '344119058648984');
INSERT INTO kunde (name, kreditkarte) VALUES ('Ueli Jodler', '4882289314803531');

INSERT INTO kauf (id_kunde, id_artikel, menge, zeitpunkt) VALUES ( (SELECT id FROM kunde WHERE name = 'Angelina Frenzel'), (SELECT id FROM artikel WHERE bezeichnung = 'Mistgabel XXL'), 5, '2016-09-22 10:27:01');
INSERT INTO kauf (id_kunde, id_artikel, menge, zeitpunkt) VALUES ( (SELECT id FROM kunde WHERE name = 'Richard Harder'), (SELECT id FROM artikel WHERE bezeichnung = 'Bürolampe'), 1, '2016-11-03 16:01:55');

-- https://metacpan.org/pod/Digest::Bcrypt
-- perl -MDigest -E 'say Digest->new("Bcrypt", cost => 1, salt => "0000000000000000")->add("anna")->hexdigest;'
-- INSERT INTO user (name, berechtigung, pw_algo, algo_param, pw_hash, pw_salt) VALUES ( 'admin', 0, 'eksblowfish', 1, 'a2256abeae23a7963a3f8930655c00d1b5fc372122b3c4', '0000000000000000' );
INSERT INTO user (name, berechtigung, pw_algo, algo_param, pw_hash, pw_salt) VALUES ( 'admin', 0, 'md5', 1, 'a70f9e38ff015afaa9ab0aacabee2e13', '' );
-- perl -MDigest -E 'say Digest->new("Bcrypt", cost => 1, salt => "0000000000000000")->add("hans")->hexdigest;'
-- INSERT INTO user (name, berechtigung, pw_algo, algo_param, pw_hash, pw_salt) VALUES ( 'lager', 0, 'eksblowfish', 1, 'f663b2c87119367580b2d52cc9f6f19500b8b6a7e540f0', '0000000000000000' );
INSERT INTO user (name, berechtigung, pw_algo, algo_param, pw_hash, pw_salt) VALUES ( 'lager', 0, 'md5', 1, 'f2a0ffe83ec8d44f2be4b624b0f47dde', '' );
-- perl -MDigest -E 'say Digest->new("Bcrypt", cost => 1, salt => "0000000000000000")->add("moin")->hexdigest;'
-- INSERT INTO user (name, berechtigung, pw_algo, algo_param, pw_hash, pw_salt) VALUES ( 'stats', 1, 'eksblowfish', 0, '323c7a1728feb683b6c50933e22dfadcbaa60304a5efec', '0000000000000000' );
INSERT INTO user (name, berechtigung, pw_algo, algo_param, pw_hash, pw_salt) VALUES ( 'stats', 1, 'md5', 0, '06a998cdd13c50b7875775d4e7e9fa74', '' );

