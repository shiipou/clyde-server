module clyde

struct User {
	id          string
	name        string
	owner       user
	child_users []user
}

