package com.ticketbooking.payment.gateway;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.razorpay.Utils;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

/** Thin wrapper around the Razorpay Java SDK — real API calls, test-mode keys. */
@Component
public class RazorpayGatewayClient {

    private final RazorpayClient razorpayClient;
    private final String keySecret;

    public RazorpayGatewayClient(RazorpayClient razorpayClient,
                                  @Value("${razorpay.key-secret}") String keySecret) {
        this.razorpayClient = razorpayClient;
        this.keySecret = keySecret;
    }

    /** Creates a real Razorpay Order and returns its order id. Amount is in the given currency's major unit (e.g. rupees). */
    public String createOrder(BigDecimal amount, String currency, String receipt) {
        try {
            JSONObject request = new JSONObject();
            request.put("amount", amount.multiply(BigDecimal.valueOf(100)).intValue());
            request.put("currency", currency);
            request.put("receipt", receipt);
            Order order = razorpayClient.orders.create(request);
            return order.get("id");
        } catch (RazorpayException e) {
            throw new PaymentGatewayException("Failed to create Razorpay order", e);
        }
    }

    /** Verifies the HMAC-SHA256 signature Razorpay's Checkout returns on a successful payment. */
    public boolean verifySignature(String orderId, String paymentId, String signature) {
        try {
            JSONObject attributes = new JSONObject();
            attributes.put("razorpay_order_id", orderId);
            attributes.put("razorpay_payment_id", paymentId);
            attributes.put("razorpay_signature", signature);
            return Utils.verifyPaymentSignature(attributes, keySecret);
        } catch (RazorpayException e) {
            return false;
        }
    }
}
