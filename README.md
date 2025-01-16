# README

The setups steps expect following tools installed on the system.

- Ruby 3.3.3
- Rails 7.2.2.1

# Thought Process

The first thing I did was initiate the project with `rails new ballast_library --database=postgresql`

Then, I thought about the libraries I might have to use to make the project easier:

1. Pundit for custom permissions
2. devise for user authentication
3. ransack to make the searching easier

**Since the project is due to 48 hours, I chose to make a simple front-end first and then create a React front-end only if I have time, because it takes longer to create components.**

So I'll start by thinking the basic database entities:

- User: email, password
- Book: title, author, genre, ISBN, total_copies (default 0), all of them must not be null
- Borrow: returned (bool, def false) user_id due_to (besides the default timestamps like created at and updated at)

Before anything else, I'll make my initial git commit so that I ensure my project is safe.

## Authentication

First, I'll install devise and create users. I followed the [docs](https://github.com/heartcombo/devise) steps to installation and generated their views.

I changed the default migration so that the `User` table would also have a role, which I plan to be an `enum`: `t.integer :role, null: false, default: 0`

## Basic Dashboard

I created admin -> dashboardcontroller and member -> dashboardcontroller, each with an `index` action only, just to render the initial views and set the after sign in path for each of the roles.
