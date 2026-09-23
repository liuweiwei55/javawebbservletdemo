package com.student.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Modifier;

public abstract class BaseServlet extends HttpServlet {

    protected static final Gson gson = new GsonBuilder()
            .excludeFieldsWithModifiers(Modifier.STATIC)
            .create();
    
    protected void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }
    
    protected void sendSuccessResponse(HttpServletResponse response, String message, Object data) throws IOException {
        JsonObject json = new JsonObject();
        json.addProperty("code", 200);
        json.addProperty("message", message);
        if (data != null) {
            json.add("data", gson.toJsonTree(data));
        }
        sendJsonResponse(response, json);
    }
    
    protected void sendErrorResponse(HttpServletResponse response, int code, String message) throws IOException {
        JsonObject json = new JsonObject();
        json.addProperty("code", code);
        json.addProperty("message", message);
        sendJsonResponse(response, json);
    }
    
    protected Integer getIntegerParameter(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}