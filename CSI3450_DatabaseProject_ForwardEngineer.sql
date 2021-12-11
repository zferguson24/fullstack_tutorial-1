-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`USER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`USER` (
  `USER_ID` INT NOT NULL AUTO_INCREMENT COMMENT 'Used as a primary key to identify users.',
  `USER_EMAIL` VARCHAR(255) NOT NULL,
  `USER_PASSWORD` VARCHAR(255) NOT NULL,
  `USER_FNAME` VARCHAR(255) NOT NULL,
  `USER_LNAME` VARCHAR(255) NOT NULL,
  `USER_DOB` DATE NOT NULL,
  `USER_DATEJOIN` DATE NOT NULL,
  `USER_ADMIN` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`USER_ID`),
  UNIQUE INDEX `USER_ID_UNIQUE` (`USER_ID` ASC) VISIBLE,
  UNIQUE INDEX `USER_EMAIL_UNIQUE` (`USER_EMAIL` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`EBOOK`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`EBOOK` (
  `EBOOK_ID` INT NOT NULL AUTO_INCREMENT,
  `EBOOK_ISBN` VARCHAR(20) NULL DEFAULT '000-00-00000-00-0',
  `EBOOK_TITLE` VARCHAR(255) NOT NULL,
  `EBOOK_AUTHOR` VARCHAR(255) NULL DEFAULT 'Unknown',
  `EBOOK_GENRE` VARCHAR(100) NULL DEFAULT 'N/A',
  `EBOOK_PRICE` DECIMAL(10,2) NULL DEFAULT 0.00,
  `EBOOK_DESC` MEDIUMTEXT NULL,
  `EBOOK_PUB` DATE NULL,
  PRIMARY KEY (`EBOOK_ID`),
  UNIQUE INDEX `EBOOK_ID_UNIQUE` (`EBOOK_ID` ASC) VISIBLE,
  UNIQUE INDEX `EBOOK_ISBN_UNIQUE` (`EBOOK_ISBN` ASC) VISIBLE,
  UNIQUE INDEX `EBOOK_RETCODE_UNIQUE` (`EBOOK_RETCODE` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PURCHASES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PURCHASES` (
  `PURCHASE_ID` INT NOT NULL AUTO_INCREMENT COMMENT 'Regardless of how many books are ordered by a user at once, we will have a row for each book purchased by a given user.',
  `USER_ID` INT NOT NULL,
  `EBOOK_ID` INT NOT NULL,
  `PURCHASE_DATE` DATE NOT NULL,
  PRIMARY KEY (`PURCHASE_ID`, `USER_ID`, `EBOOK_ID`),
  UNIQUE INDEX `ORDER_ID_UNIQUE` (`PURCHASE_ID` ASC) VISIBLE,
  INDEX `fk_PURCHASES_USER1_idx` (`USER_ID` ASC) VISIBLE,
  INDEX `fk_PURCHASES_EBOOK1_idx` (`EBOOK_ID` ASC) VISIBLE,
  CONSTRAINT `fk_PURCHASES_USER1`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PURCHASES_EBOOK1`
    FOREIGN KEY (`EBOOK_ID`)
    REFERENCES `mydb`.`EBOOK` (`EBOOK_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'True';


-- -----------------------------------------------------
-- Table `mydb`.`REVIEWS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`REVIEWS` (
  `REVIEW_ID` INT NOT NULL AUTO_INCREMENT,
  `USER_ID` INT NOT NULL,
  `EBOOK_ID` INT NOT NULL,
  `REVIEW_VERIFIED` TINYINT NOT NULL,
  `REVIEW_TIMESTAMP` DATETIME NOT NULL,
  `REVIEW_RATING` TINYINT NOT NULL,
  `REVIEW_DESC` MEDIUMTEXT NULL,
  PRIMARY KEY (`REVIEW_ID`, `USER_ID`, `EBOOK_ID`),
  UNIQUE INDEX `REVIEW_ID_UNIQUE` (`REVIEW_ID` ASC) VISIBLE,
  INDEX `fk_REVIEWS_USER1_idx` (`USER_ID` ASC) VISIBLE,
  INDEX `fk_REVIEWS_EBOOK1_idx` (`EBOOK_ID` ASC) VISIBLE,
  CONSTRAINT `fk_REVIEWS_USER1`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_REVIEWS_EBOOK1`
    FOREIGN KEY (`EBOOK_ID`)
    REFERENCES `mydb`.`EBOOK` (`EBOOK_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`COUPON`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`COUPON` (
  `COUPON_ID` INT NOT NULL AUTO_INCREMENT,
  `USER_ID` INT NULL,
  `COUPON_CODE` VARCHAR(25) NULL,
  `COUPON_PERCENT` DECIMAL NOT NULL DEFAULT 0.00,
  `COUPON_EXPIREDATE` DATE NOT NULL,
  PRIMARY KEY (`COUPON_ID`),
  UNIQUE INDEX `COUPON_ID_UNIQUE` (`COUPON_ID` ASC) VISIBLE,
  INDEX `fk_COUPON_USER1_idx` (`USER_ID` ASC) VISIBLE,
  CONSTRAINT `fk_COUPON_USER1`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`VOLUME`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`VOLUME` (
  `VOLUME_ID` INT NOT NULL AUTO_INCREMENT,
  `EBOOK_ID` INT NOT NULL,
  `VOLUME_SOLD` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`VOLUME_ID`, `EBOOK_ID`),
  UNIQUE INDEX `VOLUME_ID_UNIQUE` (`VOLUME_ID` ASC) VISIBLE,
  INDEX `fk_VOLUME_EBOOK1_idx` (`EBOOK_ID` ASC) VISIBLE,
  CONSTRAINT `fk_VOLUME_EBOOK1`
    FOREIGN KEY (`EBOOK_ID`)
    REFERENCES `mydb`.`EBOOK` (`EBOOK_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`LIBRARY`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`LIBRARY` (
  `LIBRARY_ID` INT NOT NULL AUTO_INCREMENT,
  `USER_ID` INT NOT NULL,
  `EBOOK_ID` INT NOT NULL,
  PRIMARY KEY (`LIBRARY_ID`, `USER_ID`),
  INDEX `fk_USER_has_EBOOK_USER_idx` (`USER_ID` ASC) VISIBLE,
  INDEX `fk_LIBRARY_EBOOK1_idx` (`EBOOK_ID` ASC) VISIBLE,
  CONSTRAINT `fk_USER_has_EBOOK_USER`
    FOREIGN KEY (`USER_ID`)
    REFERENCES `mydb`.`USER` (`USER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LIBRARY_EBOOK1`
    FOREIGN KEY (`EBOOK_ID`)
    REFERENCES `mydb`.`EBOOK` (`EBOOK_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`AVERAGE_RATING`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`AVERAGE_RATING` (
  `AVERAGE_RATING_ID` INT NOT NULL AUTO_INCREMENT,
  `EBOOK_ID` INT NOT NULL,
  `AVERAGE_RATING_NUMBER` DECIMAL NOT NULL DEFAULT 0,
  `AVERAGE_RATING_TOTAL` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`AVERAGE_RATING_ID`, `EBOOK_ID`),
  UNIQUE INDEX `AVERAGE_RATING_ID_UNIQUE` (`AVERAGE_RATING_ID` ASC) VISIBLE,
  INDEX `fk_AVERAGE_RATING_EBOOK1_idx` (`EBOOK_ID` ASC) VISIBLE,
  CONSTRAINT `fk_AVERAGE_RATING_EBOOK1`
    FOREIGN KEY (`EBOOK_ID`)
    REFERENCES `mydb`.`EBOOK` (`EBOOK_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

ALTER TABLE EBOOK DROP COLUMN EBOOK_RETCODE;

desc USER;
desc EBOOK;
desc PURCHASES;
desc REVIEWS;
desc COUPON;
desc LIBRARY;
desc VOLUME;
desc AVERAGE_RATING;

INSERT INTO `USER` (USER_ID, USER_EMAIL, USER_PASSWORD, USER_FNAME, USER_LNAME, USER_DOB, USER_DATEJOIN, USER_ADMIN) VALUES
	(1, 'zferguson@oakland.edu', sha1('dart monkey'), 'Zach', 'Ferguson', '2001-01-07', NOW(), 1);
    
INSERT INTO `EBOOK` (EBOOK_ID, EBOOK_ISBN, EBOOK_TITLE, EBOOK_AUTHOR, EBOOK_GENRE, EBOOK_PRICE, EBOOK_DESC, EBOOK_PUB) VALUES
	(1, '978-05-53293-35-7', 'Foundation', 'Isaac Asimov', 'Science Fiction', '7.99', 'For twelve thousand years the Galactic Empire has ruled supreme. 
    Now it is dying. But only Hari Seldon, creator of the revolutionary science of psychohistory, can see into the future—to a dark age of ignorance, barbarism, and warfare
    that will last thirty thousand years. To preserve knowledge and save humankind, Seldon gathers the best minds in the Empire—both scientists and scholars—
    and brings them to a bleak planet at the edge of the galaxy to serve as a beacon of hope for future generations. He calls his sanctuary the Foundation.\n\n
    The Foundation novels of Isaac Asimov are among the most influential in the history of science fiction, celebrated for their unique blend of breathtaking action
    , daring ideas, and extensive worldbuilding. In Foundation, Asimov has written a timely and timeless novel of the best—and worst—that lies in humanity, 
    and the power of even a few courageous souls to shine a light in a universe of darkness.', '1951-01-01');
