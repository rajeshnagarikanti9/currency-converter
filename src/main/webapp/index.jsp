<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Currency Converter 💱</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #87CEFA;
        }
        form {
            background-color: #fff;
            padding: 25px;
            width: 400px;
            border-radius: 8px;
            box-shadow: 0 0 10px #ccc;
        }
        input, select, button {
            width: 100%;
            padding: 8px;
            margin-top: 8px;
            margin-bottom: 16px;
        }
        h2 {
            text-align: center;
            color: #87CEFA;          /* Changed color (Light sky Blue) */
            font-family: 'Gothic'; /* Changed font style */
            font-size: 28px;         /* Changed font size */
            margin-bottom: 20px;
        }
        .result {
            font-weight: bold;
            color: green;
            text-align: center;
        }
        .error {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>
    <form action="convert" method="post">
        <h2> Currency Converter</h2>

        <label>Amount:</label>
        <input type="text" name="amount" required>

        <label>From Currency:</label>
        <select name="fromCurrency">
            <option>USD</option>
            <option>EUR</option>
            <option>INR</option>
            <option>GBP</option>
            <option>JPY</option>
        </select>

        <label>To Currency:</label>
        <select name="toCurrency">
            <option>USD</option>
            <option>EUR</option>
            <option>INR</option>
            <option>GBP</option>
            <option>JPY</option>
        </select>

        <button type="submit">Convert</button>

        <% if (request.getAttribute("result") != null) { %>
            <p class="result">Converted Amount: <%= request.getAttribute("result") %></p>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
    </form>
</body>
</html>
