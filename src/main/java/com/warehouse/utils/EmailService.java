package com.warehouse.utils;

import com.warehouse.dao.ProductDAO;
import com.warehouse.models.Product;
import com.warehouse.models.ReorderItem;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class EmailService {

    public static void sendReorderEmail(String to, String supplierName, List<ReorderItem> items) {
        ProductDAO productDAO = new ProductDAO();
        List<String[]> reorderLines = new ArrayList<>();

        for (ReorderItem item : items) {
            Product p = productDAO.getProductById(item.getProductId());
            reorderLines.add(new String[]{
                    p.getProductName(),
                    p.getCategoryName(),
                    String.valueOf(p.getWeightValue()),
                    String.valueOf(item.getQuantity())
            });
        }

        EmailUtil.sendReorderEmail(to, supplierName, reorderLines);
    }
}
