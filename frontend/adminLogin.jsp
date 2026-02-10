

<!DOCTYPE html>
<html>
<head>
<title>Admin Login</title>

<style>
body{
    font-family:Segoe UI, Arial;
    background:#f1f5f9;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
}

.box{
    background:white;
    padding:30px;
    width:300px;
    border-radius:6px;
    box-shadow:0 0 10px rgba(0,0,0,0.1);
    text-align:center;
}

h2{
    margin-bottom:20px;
}

input{
    width:90%;
    padding:10px;
    margin:8px 0;
}

button{
    padding:10px 20px;
    background:#2563eb;
    color:white;
    border:none;
    border-radius:4px;
    cursor:pointer;
    width:100%;
}

#error{
    color:red;
    margin-top:10px;
}
</style>
</head>

<body>

<div class="box">
    <h2>Admin Login</h2>

    <form method="post">
        <input type="text" name="username" placeholder="Username" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Login</button>
    </form>

    <p id="error">
        <%
        if(request.getAttribute("error")!=null){
            out.print(request.getAttribute("error"));
        }
        %>
    </p>
</div>

<%
/* LOGIN LOGIC */
String user = request.getParameter("username");
String pass = request.getParameter("password");

if(user != null && pass != null){

    // 🔐 SIMPLE ADMIN CHECK (change later if needed)
    if(user.equals("admin") && pass.equals("admin123")){

        session.setAttribute("admin", user);   // ✅ IMPORTANT
        response.sendRedirect("adminDashboard.jsp");

    }else{
        request.setAttribute("error","Invalid Username or Password");
        RequestDispatcher rd =
            request.getRequestDispatcher("adminLogin.jsp");
        rd.forward(request,response);
    }
}
%>

</body>
</html>
