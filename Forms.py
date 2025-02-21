from wtforms import Form, validators, StringField, TextAreaField, PasswordField, SelectField, HiddenField
from wtforms.fields import DateField
from wtforms_components import DateRange
from datetime import date
from flask_wtf import RecaptchaField
import re

class SearchBarForm(Form):
    searchQuery = StringField('Search Query', render_kw={"placeholder": "Search for a post..."})
    topic = SelectField('Topic')

class FeedbackForm(Form):
    userID = HiddenField()
    reason = StringField('Reason', [validators.DataRequired()], render_kw={"placeholder": "e.g. Feedback regarding post moderation"})
    comment = TextAreaField('Comment', [validators.DataRequired()], render_kw={"rows": 10, "placeholder": "Enter comment here..."})

class LoginForm(Form):
    recaptcha = RecaptchaField()
    username = StringField('Username', [validators.DataRequired()])
    password = PasswordField('Password', [validators.DataRequired()])

class SignUpForm(Form):
    today = str(date.today())
    year, month, day = today.split('-')
    minYear = int(year) - 13
    month, day = int(month), int(day)

    email = StringField('Email Address', [validators.DataRequired(), validators.Regexp(r'^.+@[^.].*\.[a-z]{2,10}$', message="Invalid email address.")])
    username = StringField('Username', [validators.DataRequired()])
    dob = DateField('Date of Birth', [DateRange(max=date(minYear, month, day), message="You have to be at least 13 years old to register for an account.")])
    status = StringField('Status')
    password = PasswordField('New Password', [
        validators.DataRequired(),
        validators.Regexp(re.compile('^(?=\S{10,20}$)(?=.*?\d)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^A-Za-z\s0-9])'), message= "Password must contain 10-20 characters, number, uppercase, lowercase, special character."),
        validators.EqualTo('confirmPassword', message='Passwords do not match.')
    ])
    confirmPassword = PasswordField('Re-enter Password', [validators.DataRequired()])

class UpdateEmail(Form):
    email = StringField('Email Address', [validators.DataRequired(), validators.Regexp(r'^.+@[^.].*\.[a-z]{2,10}$', message="Invalid email address.")])

class UpdateUsername(Form):
    username = StringField('Username', [validators.DataRequired()])

class UpdateStatus(Form):
    status = StringField('Status')

class UpdatePassword(Form):
    password = PasswordField('New Password', [
        validators.DataRequired(),
        validators.Regexp(re.compile('^(?=\S{10,20}$)(?=.*?\d)(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[^A-Za-z\s0-9])'), message= "Password must contain 10-20 characters, number, uppercase, lowercase, special character."),
        validators.EqualTo('confirmPassword', message='Passwords do not match.')
    ])
    confirmPassword = PasswordField('Re-enter Password', [validators.DataRequired()])

class PostForm(Form):
    userID = HiddenField()
    topic = SelectField('Topic')
    title = StringField('Title', [validators.DataRequired()], render_kw={"placeholder": "e.g. Error Exception handling in Python"})
    content = TextAreaField('Content', [validators.DataRequired()], render_kw={"rows": 10, "placeholder": "Enter content here..."})

class CommentForm(Form):
    userID = HiddenField()
    comment = TextAreaField('Comment', [validators.DataRequired()], render_kw={"rows": 3, "placeholder": "Enter comment here..."})

class ReplyForm(Form):
    userID = HiddenField()
    repliedID = HiddenField()
    reply = TextAreaField('Comment', [validators.DataRequired()], render_kw={"rows": 3, "placeholder": "Enter comment here..."})

class ReplyFeedbackForm(Form):
    # repliedID = HiddenField()
    reply = TextAreaField('Reply', [validators.DataRequired()], render_kw={"rows": 3, "placeholder": "Enter reply here..."})

class TopicForm(Form):
    topic = StringField('Topic', [validators.DataRequired()])

class OTPForm(Form):
    otp = StringField('OTP', [validators.DataRequired()])

class ReactivateForm(Form):
    reason = SelectField('Why was your account locked?',[validators.DataRequired()], choices=[(1,"This wasn't me"), (2,'I forgot my password.'), (3,'I exceeded the maximum number of login attempts')], coerce=int)
