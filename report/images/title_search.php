<?php
    function search($keyword)
    {
        echo "<h3>Search result</h3>";
        require_once 'connection.inc';
        //create connection
        $conn = @new mysqli($servername, $username, $password);
        $conn->set_charset("utf8");
        //check connection
        if ($conn->connect_error)
        {
            die("Connection failed: " . $conn->connect_error);
        }
    
        //select db
        $db = "music";
        if ($conn->select_db($db) == false)
            echo "Couldn't select the '$db' DB";

        //trim keyword
        $keyword = trim($keyword);
        $new_kw = str_replace(" ", "%' or tieude like '%", $keyword);

        //query to join 3 tables
        $sql = "select ma_bviet, tieude, ten_tgia, ngayviet, ten_bhat, ten_tloai, left(tomtat, 50) as tomtat from baiviet 
                join tacgia on baiviet.ma_tgia = tacgia.ma_tgia
                join theloai on baiviet.ma_tloai = theloai.ma_tloai
                where tieude like '%$new_kw%'";
        $result = $conn->query($sql)
            or die("Query failed: " . $conn->error);
        
        echo "<table>";
        if ($result->num_rows > 0)
        {
        while ($row = $result->fetch_assoc())
        {
        echo "<tr>";
            echo "<td style='vertical-align: top;text-align: right;'>"."Mã bài viết"."</td>";
            echo "<td style='text-align: left;'>" . $row['ma_bviet'] . "</td>";
        echo "</tr>";
        echo "<tr>";
            echo "<td style='vertical-align: top;text-align: right;'>"."Tiêu đề"."</td>";
            echo "<td style='text-align: left;'>" . $row['tieude'] . "</td>";
        echo "</tr>";
        echo "<tr>";
            echo "<td style='vertical-align: top;text-align: right;'>"."Tác giả"."</td>";
            echo "<td style='text-align: left;'>" . $row['ten_tgia'] . "</td>";
        echo "</tr>";
        echo "<tr>";
            echo "<td style='vertical-align: top;text-align: right;'>"."Ngày viết"."</td>";
            echo "<td style='text-align: left;'>" . $row['ngayviet'] . "</td>";
        echo "</tr>";
        echo "<tr>";
            echo "<td style='vertical-align: top;text-align: right;'>"."Bài hát"."</td>";
            echo "<td style='text-align: left;'>" . $row['ten_bhat'] . "</td>";
        echo "</tr>";
        echo "<tr>";
            echo "<td style='vertical-align: top;text-align: right;'>"."Thể loại"."</td>";
            echo "<td style='text-align: left;'>" . $row['ten_tloai'] . "</td>";
        echo "</tr>";
        echo "<tr style='border-bottom:1px solid black;'>";
            echo "<td style='vertical-align: top;text-align: right;'>"."Tóm tắt"."</td>";
            echo "<td style='text-align: left;'>" . $row['tomtat'] . "</td>";
        echo "</tr>";
        }
        }
        else 
            echo "No title found";
        echo "</table>";
    }
?>