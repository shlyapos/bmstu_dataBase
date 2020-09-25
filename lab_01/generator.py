from faker import Faker
import hashlib
from random import randint

maxn = 1000
faker = Faker()
sourcePath = "./source"

def passwordGenerator():
    global faker

    password = faker.password(length=16, digits=True, upper_case=True)
    salt = faker.password(length=6, digits=True, upper_case=True)

    return salt, hashlib.md5((password + salt).encode('utf-8'))


def accountGenerator():
    global faker

    filePath = sourcePath + "/account.csv"
    f = open(filePath, 'w')

    for i in range(maxn):
        salt, hashPassword = passwordGenerator()

        row = "{0},{1},{2},{3}\n".format(faker.user_name(), faker.ascii_free_email(), salt, hashPassword.hexdigest())
        f.write(row)
    
    f.close()


def textGenerator():
    global faker

    filePath = sourcePath + "/post_text.csv"
    f = open(filePath, 'w')

    for i in range(maxn):
        f.write("{0}\n".format(faker.sentences()[0]))

    f.close()


def tagGenerator():
    global faker

    filePath = sourcePath + "/tag.csv"
    f = open(filePath, 'w')

    for i in range(maxn):
        f.write("{0}\n".format(faker.word()))
    
    f.close()


def pictureGenerator():
    global faker

    filePath = sourcePath + "/picture.csv"
    f = open(filePath, 'w')

    formats = ["png", "jpeg", "jpg", "bmp"]

    for i in range(maxn):
        picturePath = "{0}".format(faker.url())
        picturePath += faker.password(length=8, digits=False, upper_case=False)
        picturePath += '.' + formats[randint(0, len(formats) - 1)] + '\n'

        f.write(picturePath)
    
    f.close()


def reviewGenerator():
    global faker

    filePath = sourcePath + "/review.csv"
    f = open(filePath, 'w')

    for i in range(maxn):
        row = "{0}, {1}, {2}, {3}, {4}\n".format(randint(1, 1000), randint(1, 1000), 
                                                 faker.sentences(nb=1)[0], randint(1, 10),
                                                 faker.date())
        f.write(row)

    f.close()


def postGenerator():
    global faker

    filePath = sourcePath + "/post.csv"
    f = open(filePath, 'w')

    for i in range(maxn):
        f.write("{0}, {1}, {2}\n".format(randint(1, 1000), faker.word(), faker.date()))

    f.close()


def connectionGenerator(filePath):
    global faker

    f = open(filePath, 'w')

    for i in range(maxn):
        f.write("{0}, {1}\n".format(randint(1, 1000), randint(1, 1000)))
    
    f.close()


def pictureConnectionGenerator():
    connectionGenerator(sourcePath + "/tag_to_picture.csv")
    connectionGenerator(sourcePath + "/picture_to_post.csv")


def textToConnectionGenerator():
    connectionGenerator(sourcePath + "/tag_to_text.csv")
    connectionGenerator(sourcePath + "/text_to_post.csv")


def main():
    accountGenerator()
    textGenerator()
    tagGenerator()
    pictureGenerator()
    reviewGenerator()
    postGenerator()

    pictureConnectionGenerator()
    textToConnectionGenerator()


main()