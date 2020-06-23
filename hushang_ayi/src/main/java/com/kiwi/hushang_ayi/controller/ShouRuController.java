package com.kiwi.hushang_ayi.controller;

import com.kiwi.hushang_ayi.service.ShouRuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import utils.JsonResult;
import utils.LayUIUtil;
import utils.TypeUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class ShouRuController {

    @Autowired
    ShouRuService shouRuService;

    @RequestMapping(value = "/getShouRuByMonth", method = RequestMethod.POST)
    public LayUIUtil getShouRuByMonth(String dateYM, Integer page, Integer size) throws Exception{

        int date = TypeUtil.toInt(dateYM);

        List<Map<String, Object>> shouRuByMonth = shouRuService.getShouRuByMonth(date);
        int count = shouRuByMonth.size();

        return LayUIUtil.data(count, shouRuByMonth);
    }

    @RequestMapping(value = "/getShouRuByMonthEcharts", method = RequestMethod.POST)
    public Map<String, Object> getShouRuByMonthEcharts(String dateYM) throws Exception{

        int date = TypeUtil.toInt(dateYM);

        List<Map<String, Object>> shouRuByMonth = shouRuService.getShouRuByMonth(date);
        List<String> echartsMoney = new ArrayList<>();
        List<String> echartsTime = new ArrayList<>();
        for (Map<String, Object> shouRuByMonthMap : shouRuByMonth){

            echartsMoney.add(TypeUtil.toString(shouRuByMonthMap.get("shouru_money")));
            echartsTime.add(TypeUtil.toString(shouRuByMonthMap.get("shouru_time")));
        }
        Map<String, Object> result = new HashMap<>();
        result.put("echartsMoney",echartsMoney);
        result.put("echartsTime",echartsTime);
        return result;
    }

    @RequestMapping(value = "/getShouRuByMonthDay", method = RequestMethod.POST)
    public LayUIUtil getShouRuByMonthDay(String dateYMD, Integer page, Integer size) throws Exception{

        int date = TypeUtil.toInt(dateYMD);

        List<Map<String,Object>> shouRuByMonthDay = shouRuService.getShouRuByMonthDay(date);
        int count = shouRuByMonthDay.size();

        return LayUIUtil.data(count, shouRuByMonthDay);
    }

    @RequestMapping(value = "/getShouRuByMonthExcel", method = RequestMethod.POST)
    public JsonResult getShouRuByMonthExcel(@RequestBody Map<String,String> requestMap) throws Exception{

        int date = TypeUtil.toInt(requestMap.get("dateYM"));

        List<Map<String, Object>> shouRuByMonth = shouRuService.getShouRuByMonth(date);
        Map<String, Object> map = new HashMap<>();
        map.put("dateYMD", date);
        Map<String, Object> srCountByYM = shouRuService.getSRCountByYM(map);
        map.put("shouru_money","合计");
        map.put("shouru_time",srCountByYM.get("shouRuCount"));
        shouRuByMonth.add(map);
        return new JsonResult(shouRuByMonth);
    }

    @RequestMapping(value = "/insertShouRuData", method = RequestMethod.POST)
    public Map<String, Object> insertShouRuData(String insertShouRuData, String insertDATEYMD) throws Exception{

        Double shouRuData = TypeUtil.toDouble(insertShouRuData);
        Long dateYMD = TypeUtil.toLong(insertDATEYMD);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("shouRuData", shouRuData);
        map.put("dateYMD", dateYMD);
        Map<String, Object> result = shouRuService.insertShouRuData(map);

        return result;
    }

    @RequestMapping(value = "/getSRCountByYM", method = RequestMethod.POST)
    public Map<String, Object> getSRCountByYM(@RequestBody Map<String,String> requestMap) throws Exception{

        Long dateYMD = TypeUtil.toLong(requestMap.get("dateYM"));
        Map<String, Object> map = new HashMap<>();
        map.put("dateYMD", dateYMD);
        Map<String, Object> srCountByYM = shouRuService.getSRCountByYM(map);
        return srCountByYM;
    }
}
