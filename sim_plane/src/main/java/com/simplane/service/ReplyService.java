package com.simplane.service;

import com.simplane.domain.Criteria;
import com.simplane.domain.ReplyPageDTO;
import com.simplane.domain.ReplyVO;

public interface ReplyService {
    
    //댓글 단건 조회
    public ReplyVO get(Long replyid);

    //댓글 목록 조회 + 페이징
    public ReplyPageDTO getListPage(Criteria cri, Long boardid);

    //댓글 수정
    public Long modify(ReplyVO vo);
}
