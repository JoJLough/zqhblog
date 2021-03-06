package com.zqh.blog.service;

import com.zqh.blog.entity.ArticleInfo;
import com.zqh.blog.mapper.BaseMapper;
import com.zqh.blog.utils.PageUtil;
import com.zqh.blog.vo.Page;
import org.springframework.stereotype.Service;

import java.io.Serializable;
import java.security.PublicKey;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * author: zqh
 * email：zqhfsf@gmail.com
 * date: 2018/1/21 0021 下午 9:13
 * description: service 父类
 **/
public class BaseService<T, PK extends Serializable> {

    private BaseMapper<T, PK> baseMapper;

    public BaseService() {
    }

    public BaseService(BaseMapper<T, PK> baseMapper) {
        this.baseMapper = baseMapper;
    }

    /**
     * 插入操作
     *
     * @param t 插入的对象
     */
    public int insert(T t) {
        return baseMapper.insert(t);
    }

    /**
     * 根据主键删除
     *
     * @param pk 主键
     */
    public int deleteById(PK pk) {
        return baseMapper.deleteById(pk);
    }

    /**
     * 修改操作
     *
     * @param t 对象
     */
    public int update(T t) {
        return baseMapper.update(t);
    }

    /**
     * 根据主键查询操作
     *
     * @param pk 主键
     * @return
     */
    public T selectById(PK pk) {
        return baseMapper.selectById(pk);
    }

    /**
     * 条件查询
     *
     * @param map 封装条件的map对象
     * @return
     */
    public List<T> selectList(Map map) {
        return baseMapper.selectList(map);
    }

    /**
     * 分页查询
     *
     * @param curr 第几页
     * @param limit 条数
     * @return
     */
    public Page<ArticleInfo> selectByPage(Integer curr, Integer limit) {
        if (curr < 1 || limit < 1) {
            curr = 1;limit = 10;
        }

        Map<String, Integer> map = new HashMap<>();
        map.put("start", (curr - 1) * limit);
        map.put("limit", limit);
        List<T> ts = baseMapper.selectByPage(map);

        map.clear();
        int total = baseMapper.selectCount(map);
        int pageSize = (int) Math.ceil(total / (double) limit);

        Page<ArticleInfo> page = new Page<>();
        page.setLists((List<ArticleInfo>) ts)
                .setCurr(curr)
                .setPageLine(PageUtil.pcnDefault(curr, pageSize))
                .setSize(limit)
                .setPageSize(pageSize);
        return page;
    }

    /**
     * 根据条件，查询出记录数
     * @param map
     * @return
     */
    public int getCount(Map map) {
        return baseMapper.selectCount(map);
    }
}
