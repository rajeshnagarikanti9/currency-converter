package com.ajacs.currencyconverter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.HashMap;

public class CurrencyConverterServlet extends HttpServlet {

    private HashMap<String, Double> exchangeRates;

    @Override
    public void init() {
        exchangeRates = new HashMap<>();
        exchangeRates.put("USD", 1.0);
        exchangeRates.put("EUR", 0.93);
        exchangeRates.put("INR", 95.12);
        exchangeRates.put("GBP", 0.79);
        exchangeRates.put("JPY", 149.36);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            double amount = Double.parseDouble(request.getParameter("amount"));
            String from = request.getParameter("fromCurrency");
            String to = request.getParameter("toCurrency");

            double fromRate = exchangeRates.get(from);
            double toRate = exchangeRates.get(to);
            double converted = (amount / fromRate) * toRate;

            DecimalFormat df = new DecimalFormat("0.00");

            request.setAttribute("result", df.format(converted) + " " + to);
            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Please enter a valid number!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
