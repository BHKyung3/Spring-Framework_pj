package com.simplane.service;

import com.simplane.domain.ReplyVO;
import com.simplane.mapper.BoardMapper;
import com.simplane.mapper.ReplyMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Log4j
public class ReplyServiceImpl implements ReplyService {

    @Autowired
    private final ReplyMapper mapper;
    @Autowired
    private final BoardMapper boardMapper;

    @Override
    @Transactional // 실패 했다면 다른 하나도 실패하게 한다
    public int register(ReplyVO vo) {

        boardMapper.updateReplyCnt(vo.getBno(), 1);
        return mapper.insert(vo);
    }


}
