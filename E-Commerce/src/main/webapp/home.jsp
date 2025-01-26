<%@ page import="lk.ijse.DTO.ProductDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="lk.ijse.DAO.LoginDAO" %>
<%@ page import="lk.ijse.DAO.UserDAO" %>
<%@ page import="lk.ijse.DAO.DAOFactory" %>
<%@ page import="lk.ijse.Entity.Login" %>
<%@ page import="lk.ijse.Entity.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String alertType = (String) request.getAttribute("alertType");
    String alertMessage = (String) request.getAttribute("alertMessage");
    List<ProductDTO> dataList = (List<ProductDTO>) request.getAttribute("homeProducts");
    UserDAO userDAO = (UserDAO) DAOFactory.getDaoFactory().getDAO(DAOFactory.DaoType.User);
    LoginDAO loginDAO = (LoginDAO) DAOFactory.getDaoFactory().getDAO(DAOFactory.DaoType.Login);
    Login login = loginDAO.getLastLogin();
    User user = userDAO.searchByEmail(login.getUserMail());

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home Page</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


</head>
<style>
    /* General Styles */
    body {
        background-color: #f8f9fa;
        font-family: 'Inter', sans-serif;
    }

    /* Navbar */
    .navbar {
        background-color: #343a40 !important;
    }

    .navbar-brand, .nav-link {
        color: #ffffff !important;
        font-weight: 500;
    }

    .nav-link:hover {
        color: #ff6b6b !important;
    }

    /* Search Bar */
    .form-control {
        border-radius: 20px;
    }
    .btn-outline-success {
        border-radius: 20px;
        border-color: #ff6b6b;
        color: #ff6b6b;
    }
    .btn-outline-success:hover {
        background-color: #ff6b6b;
        color: white;
    }

    /* Product Cards */
    .card {
        border: none;
        border-radius: 15px;
        transition: 0.3s ease-in-out;
    }
    .card:hover {
        transform: scale(1.05);
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.2);
    }
    .card-img-wrapper {
        height: 200px;
        overflow: hidden;
        border-top-left-radius: 15px;
        border-top-right-radius: 15px;
    }
    .card-img-wrapper img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .card-body {
        text-align: center;
    }
    .card-title {
        font-weight: bold;
        color: #343a40;
    }
    .card-text {
        color: #6c757d;
    }

    /* Quantity Input */
    input[type='number'] {
        border-radius: 5px;
        text-align: center;
    }

    /* Add to Cart Button */
    .btn-primary {
        background-color: #ff6b6b;
        border: none;
        border-radius: 10px;
        transition: 0.3s;
    }
    .btn-primary:hover {
        background-color: #e35d5d;
    }


</style>
<body>
<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">BestCD</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <%if(user.getRole().equals("Admin")){%>
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/homeProduct">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="Category.jsp">Category</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/Product-List">Products</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/CheckoutServlet">Cart</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Order</a></li>
                <li class="nav-item"><a class="nav-link" href="UserDelete.jsp">Account</a></li>
                <li class="nav-item"><a class="nav-link" href="index.jsp">Log out</a></li>
            </ul>
            <%} else if (user.getRole().equals("Customer")) {%>
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/homeProduct">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/CheckoutServlet">Cart</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Order</a></li>
                <li class="nav-item"><a class="nav-link" href="UserDelete.jsp">Account</a></li>
                <li class="nav-item"><a class="nav-link" href="index.jsp">Log out</a></li>
            </ul>
            <%}%>
            <!-- Search Bar -->
            <form class="d-flex" role="search">
                <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                <button class="btn btn-outline-success" type="submit">Search</button>
            </form>

        </div>
    </div>
</nav>

<!-- Product Cards Section -->
<div class="container mt-5">
    <h2 class="text-center mb-4"></h2>
    <div class="row">
        <% if (dataList != null && !dataList.isEmpty()) { %>
        <% for (ProductDTO productDTO : dataList) { %>
        <div class="col-md-4 col-lg-3 mb-4">
            <div class="card shadow-sm">
                <div class="card-img-wrapper">
                    <img src="lib/<%= productDTO.getImagePath() %>" class="card-img-top" alt="<%= productDTO.getName() %>">
                </div>
                <div class="card-body">
                    <h5 class="card-title"><%= productDTO.getName() %></h5>
                    <p class="card-text">Price: $<%= productDTO.getPrice() %></p>
                    <form action="AddToCartServlet" method="post">
                    <div class="mb-3 d-flex align-items-center">
                        <label for="quantity_<%= productDTO.getName() %>" class="me-2">Qty:</label>
                        <input type="number" id="quantity_<%= productDTO.getName() %>" name="quantity" class="form-control" style="width: 70px;" min="1" max="<%= productDTO.getQuantity() %>" required>
<%--
                        <input id="price" type="number" step="0.01" name="price" class="form-control" placeholder="Enter Price" required>
--%>

                    </div>

                    <p class="card-text">Description: <%= productDTO.getDescription() %></p>
                    <p class="card-text">Available Stock: <%= productDTO.getQuantity() %></p>
                    <p class="card-text">Category: <%= productDTO.getCategory().getName() %></p>
                        <input type="hidden" name="productName" value="<%= productDTO.getName() %>">
                        <input type="hidden" name="productPrice" value="<%= productDTO.getPrice() %>">
                        <button type="submit" class="btn btn-primary w-100">Add to Cart</button>
                    </form>
                </div>
            </div>
        </div>
        <% } %>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const alertType = '<%= alertType != null ? alertType : "" %>';
    const alertMessage = '<%= alertMessage != null ? alertMessage : "" %>';

    if (alertType && alertMessage) {
        Swal.fire({
            icon: alertType,
            title: alertType.charAt(0).toUpperCase() + alertType.slice(1),
            text: alertMessage,
            confirmButtonText: 'OK'
        }).then(() => {
            if (alertType === 'success') {
                window.location.href = "home.jsp";
            }
        });
    }
</script>

</body>
</html>





<%--
image path = 10 amazing Apple iPhone hacks you might not be aware of.jpeg
image path = ALISISTER Mens 3D Hoodies Funny Digital Print Hooded Pullover Sweatshirt With Fleece Plush S-XXL.jpeg
image path = Gerryellis Shoes men Sneakers Male casual Mens Shoes tenis Luxury shoes Trainer Race Breathable Shoes fashion loafers running Shoes for men 2093-39.jpeg
image path = Helmut Lang.jpeg
image path = Inspiration 67 _ Chairs — Saturday School.jpeg
image path = Reflective Techwear Shoes - Black _ 6_5 US _ 39 EU.jpeg
image path = URBAN TREK ELEVATE SNEAKERS - Gray _ 42.jpeg

--%>