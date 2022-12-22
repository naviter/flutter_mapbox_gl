// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.mapbox.mapboxgl;

import java.io.IOException;
import java.lang.System;
import okhttp3.OkHttpClient;
import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class CustomHttpInterceptor implements Interceptor {
  public HashMap<String,String> CustomHeaders = new HashMap<String, String>();
  public List<String> Filter = new ArrayList<String>();

  @Override
  public Response intercept(Interceptor.Chain chain) throws IOException {           
    Response response = null;
    try {
      Request request = chain.request();
      Request.Builder builder = request.newBuilder();
      for (String pattern : Filter) {
        if (request.url().toString().contains(pattern)) {
          for (Map.Entry<String,String> header : CustomHeaders.entrySet()) {
            builder.addHeader(header.getKey(), header.getValue());
          }
          break;
        }
      }      
      request = builder.build();
      response = chain.proceed(request);
    }
    catch(IOException e) {
      throw e;
    }
    return response;
  }
}