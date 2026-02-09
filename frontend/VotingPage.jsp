<!DOCTYPE html>
<html>
<head>
    <title>Voting Page</title>
        <script>
document.addEventListener("DOMContentLoaded", function () {
    const name = localStorage.getItem("name");
    const qr = localStorage.getItem("qr");

    document.getElementById("welcome").innerText = "Welcome, " + name;
    document.getElementById("qrImg").src = "http://localhost:5000" + qr;
});
</script>

</head>
<body>

    <h2 id="welcome"></h2>

    <img id="qrImg" width="200" />

    <!-- SCRIPT MUST BE AT BOTTOM -->
    <!-- <script>
        const token = localStorage.getItem("token");
        const qr = localStorage.getItem("qr");
        const name = localStorage.getItem("name");

        document.getElementById("welcome").innerText = "Welcome, " + name;
        document.getElementById("qrImg").src = "http://localhost:5000" + qr;
    </script> -->

</body>
</html>
