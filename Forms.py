from wtforms import Form, validators, StringField, TextAreaField, PasswordField, SelectField, HiddenField

class FeedbackForm(Form):
    reason = StringField('Reason', [validators.DataRequired()], render_kw={"placeholder": "e.g. Feedback regarding post moderation"})
    comment = TextAreaField('Comment', [validators.DataRequired()], render_kw={"rows": 10, "placeholder": "Enter comment here..."})

class LoginForm(Form):
    username = StringField('Username', [validators.DataRequired()])
    password = PasswordField('Password', [validators.DataRequired()])

class SignUpForm(Form):
    email = StringField('Email Address', [validators.DataRequired()])
    username = StringField('Username', [validators.DataRequired()])
    name = StringField('Full Name', [validators.DataRequired()])
    password = PasswordField('New Password', [
        validators.DataRequired(),
        validators.EqualTo('confirmPassword', message='Passwords do not match.')
    ])
    confirmPassword = PasswordField('Re-enter Password', [validators.DataRequired()])

class PostForm(Form):
    topic = SelectField('Topic', coerce=int)
    title = StringField('Title', [validators.DataRequired()], render_kw={"placeholder": "e.g. Error Exception handling in Python"})
    content = TextAreaField('Content', [validators.DataRequired()], render_kw={"rows": 10, "placeholder": "Enter content here..."})

class CommentForm(Form):
    comment = TextAreaField('Comment', [validators.DataRequired()], render_kw={"rows": 3, "placeholder": "Enter comment here..."})

class ReplyForm(Form):
    repliedID = HiddenField()
    reply = TextAreaField('Comment', [validators.DataRequired()], render_kw={"rows": 3, "placeholder": "Enter comment here..."})
