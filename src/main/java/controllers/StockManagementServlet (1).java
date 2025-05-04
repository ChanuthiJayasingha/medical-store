import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.ArrayList;
import java.util.List;

public class StockManagementServlet extends HttpServlet {
    private static final String STOCK_FILE = "stocks.txt";

    // Helper method to read stock data from file
    private List<String> readStockData() {
        List<String> stocks = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(STOCK_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                stocks.add(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return stocks;
    }

    // Helper method to write stock data to file
    private void writeStockData(List<String> stocks) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(STOCK_FILE))) {
            for (String stock : stocks) {
                writer.write(stock);
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Create a new stock item
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String item = request.getParameter("item");
        String quantity = request.getParameter("quantity");
        if (item != null && quantity != null) {
            List<String> stocks = readStockData();
            stocks.add(item + "," + quantity);
            writeStockData(stocks);
            response.sendRedirect("stock-list.jsp");
        }
    }

    // Read and update stock
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String item = request.getParameter("item");
        String newQuantity = request.getParameter("quantity");

        List<String> stocks = readStockData();
        if ("update".equals(action) && item != null && newQuantity != null) {
            for (int i = 0; i < stocks.size(); i++) {
                String[] parts = stocks.get(i).split(",");
                if (parts[0].equals(item)) {
                    stocks.set(i, item + "," + newQuantity);
                    break;
                }
            }
            writeStockData(stocks);
        } else if ("delete".equals(action) && item != null) {
            stocks.removeIf(stock -> stock.split(",")[0].equals(item));
            writeStockData(stocks);
        }
        request.setAttribute("stocks", stocks);
        request.getRequestDispatcher("stock-list.jsp").forward(request, response);
    }
}