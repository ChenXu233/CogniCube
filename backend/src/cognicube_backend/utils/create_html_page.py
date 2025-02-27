def generate_html_page(username):
    html_content = f"""
    <html>
        <head>
            <title>Email Verification Successful</title>
        </head>
        <body>
            <h1>Welcome, {username}!</h1>
            <p>Your email has been successfully verified.</p>
        </body>
    </html>
    """
    return html_content
