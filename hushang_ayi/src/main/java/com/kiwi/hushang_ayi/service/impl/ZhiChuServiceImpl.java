package com.kiwi.hushang_ayi.service.impl;

import com.kiwi.hushang_ayi.mapper.ZhiChuMapper;
import com.kiwi.hushang_ayi.service.ZhiChuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import utils.InfoCode;
import utils.JsonResult;
import utils.TypeUtil;

import java.util.List;
import java.util.Map;

@Service
public class ZhiChuServiceImpl implements ZhiChuService {
	
	@Autowired
	private ZhiChuMapper zhiChuMapper;

	@Override
	public List<Map<String, Object>> getZhiChuByMonth(Integer dateYM){
		
		List<Map<String, Object>> zhiChuByMonth = zhiChuMapper.getZhiChuByMonth(dateYM);
		
		for (Map<String, Object> map : zhiChuByMonth) {
			
			String zhichuTime = TypeUtil.toString(map.get("zhichu_time"));
			String year = zhichuTime.substring(0, 4);
			String month = zhichuTime.substring(4, 6);
			String day = zhichuTime.substring(6, 8);
			map.put("zhichu_time", year + "-" + month + "-" + day);
		}
		return zhiChuByMonth;
	}

	@Override
	public List<Map<String, Object>> getZhiChuByYear(Integer dateYear){

		List<Map<String, Object>> zhiChuByYear = zhiChuMapper.getZhiChuByYear(dateYear);

		for (Map<String, Object> map : zhiChuByYear) {

			String zhichuTime = TypeUtil.toString(map.get("zhichu_time"));
			String year = zhichuTime.substring(0, 4);
			String month = zhichuTime.substring(4, 6);
			map.put("zhichu_time", year + "-" + month);
		}
		return zhiChuByYear;
	}

	@Override
	public List<Map<String, Object>> getZhiChuByMonthEcharts(Integer date){

		List<Map<String, Object>> zhiChuByMonthEcharts = zhiChuMapper.getZhiChuByMonthEcharts(date);

		for (Map<String, Object> map : zhiChuByMonthEcharts) {

			String zhichuTime = TypeUtil.toString(map.get("zhichu_time"));
			String year = zhichuTime.substring(0, 4);
			String month = zhichuTime.substring(4, 6);
			String day = zhichuTime.substring(6, 8);
			map.put("zhichu_time", year + "-" + month + "-" + day);
		}
		return zhiChuByMonthEcharts;
	}

	@Override
	public List<Map<String, Object>> getZhiChuByYearEcharts(Integer date){

		List<Map<String, Object>> zhiChuByYear = zhiChuMapper.getZhiChuByYear(date);

		for (Map<String, Object> map : zhiChuByYear) {

			String zhichuTime = TypeUtil.toString(map.get("zhichu_time"));
			String year = zhichuTime.substring(0, 4);
			String month = zhichuTime.substring(4, 6);
			map.put("zhichu_time", year + "-" + month);
		}
		return zhiChuByYear;
	}

	@Override
	public JsonResult insertZhiChuData(Map<String, Object> map){

		try {
			zhiChuMapper.insertZhiChuData(map);
		}catch (Exception e){
			return new JsonResult(InfoCode.SAVE_FAIL.code, InfoCode.SAVE_FAIL.msg);
		}
		return new JsonResult(InfoCode.SAVE_SUCCESS.code, InfoCode.SAVE_SUCCESS.msg);
	}

	@Override
	public Map<String, Object> getZCCountByYear(Map<String, Object> map){

		Map<String, Object> zcCountByYear = zhiChuMapper.getZCCountByYear(map);
		return zcCountByYear;
	}

	@Override
	public Map<String, Object> getZCCountByYM(Map<String, Object> map){

		Map<String, Object> zcCountByYM = zhiChuMapper.getZCCountByYM(map);
		return zcCountByYM;
	}
}