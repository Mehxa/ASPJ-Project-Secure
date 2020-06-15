import random
import string


class BlogPost:
    def __init__(self, author_id,  author_name, title, subtitle="", content):
        all_characters = string.digits + string.ascii_letters
        blog_id = ''.join((random.choice(all_characters) for i in range(8)))
        self.__id = blog_id
        self.__author_id = author_id
        self.__author_name = author_name
        self.__title = title
        self.__subtitle = subtitle
        self.__content = content
        self.__upvotes = 0

    def set_author_id(self, author_id):
        self.__author_id = author_id

    def set_author_name(self, author_name):
        self.__author_name = author_name

    def set_title(self, title):
        self.__title = title

    def set_subtitle(self, subtitle):
        self.__subtitle = subtitle

    def set_content(self, content):
        self.__content = content

    def get_id(self):
        return self.__id

    def get_author_id(self):
        return self.__author_id

    def get_author_name(self):
        return self.__author_name

    def get_title(self):
        return self.__title

    def get_subtitle(self):
        return self.__subtitle

    def get_content(self):
        return self.__content

    def upvote(self):
        self.__upvotes += 1
