<!DOCTYPE html>
<html lang="en">
<head>
    <title>Forgotten Password</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

</head>
<body>
    <div class="container">
        <h3>Forgotten Password</h3>
            <form action="checkemail.jsp" role="form" name="recoveryForm">
                <div class="form-group">
	            <label for="email">Enter your email:</label>
                    <input class="form-control" id ="email" type="email" name="email" placeholder="johnmurphy@gmail.com">
                </div>
		<button type="submit" class="btn btn-default" >Submit</button>
            </form>
    </div>
</body>
</html>
