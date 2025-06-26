package com.simplane.mapper;

import com.simplane.domain.Criteria;
import com.simplane.domain.ReplyVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ReplyMapper {

    //댓글 조회
    public ReplyVO read(Long replyid);

    //댓글 수정
    public Long update(ReplyVO reply);

    //댓글 페이징 처리
    public List<ReplyVO> getListWithPaging(
            @Param("cri") Criteria cri,
            @Param("boardid") Long boardid
    );
}
