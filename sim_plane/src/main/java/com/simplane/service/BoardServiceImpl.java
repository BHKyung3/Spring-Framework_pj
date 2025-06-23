package com.simplane.service;

import com.simplane.domain.BoardVO;
import com.simplane.domain.Criteria;
import com.simplane.mapper.BoardMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Log4j
@RequiredArgsConstructor //생성자 주입
public class BoardServiceImpl implements BoardService {

    private final BoardMapper mapper;

    @Override
    public BoardVO get(Long boardid) {
        log.info("get.........."+boardid);
        return mapper.read(boardid);
    }

    @Override
    public List<BoardVO> getAll(Criteria cri) {
        log.info("getAll..........");
        return mapper.getListWithPaging(cri);
    }

    @Override
    public int getTotal(Criteria cri) {
        log.info("getTotal...........");
        return mapper.getTotalCount(cri);
    }
    // 게시글 수정
    @Override
    public boolean modify(BoardVO board){
        log.info("modify..........1");
        log.info("update result = " + mapper.update(board));
        return mapper.update(board) == 1;
    }
}
