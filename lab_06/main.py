import database


def printMenu():
    print(">> Choose operations:")
    print(">> [ 1] - Scalar query")
    print(">> [ 2] - Query with JOIN")
    print(">> [ 3] - ")
    print(">> [ 4] - Query on metadata")
    print(">> [ 5] - Scalar function")
    print(">> [ 6] - ")
    print(">> [ 7] - Procedure")
    print(">> [ 8] - System procedure or function")
    print(">> [ 9] - Create new table")
    print(">> [10] - Insert new data")
    print(">> [11] - Delete new table")

    print("\n>> [ 0] - Exit \n")


if __name__ == "__main__":
    memesDB = database.DataBase()

    while True:
        printMenu()

        choice = int(input(">> Your choice: "))
        print('')

        if choice == 0:
            break
        elif choice == 1:
            memesDB.getReviewByDate(2016)
        elif choice == 2:
            memesDB.getTagsPicturePng()
        elif choice == 3:
            memesDB.getUsersWithoutReviews()
        elif choice == 4:
            memesDB.getTables()
        elif choice == 5:
            memesDB.getPostCount()
        elif choice == 6:
            memesDB.getUserLoginByID(32)
        elif choice == 7:
            memesDB.getConstraints()
            continue
        elif choice == 8:
            memesDB.getVersion()
        elif choice == 9:
            memesDB.createTable("user_role")
            continue
        elif choice == 10:
            role = input(">> Input role: ")
            rating_buf = input(">> Input rating difference: ")
            print('')

            memesDB.insertNewData("user_role", role, rating_buf)
            continue
        elif choice == 11:
            memesDB.dropTable("user_role")
            continue
        else:
            print('>>> Wrong command')
            continue
        
        print('')
        memesDB.printQuery()
        print('')