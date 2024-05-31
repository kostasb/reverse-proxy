#!/bin/sh
echo "> Running Test Suite"
TEST_STATUS="ok"
curl_output=`curl -vsL http://kostasbotsas.com 2>&1 -o /dev/null`
#Test for 301 redirect
test_redirect=`echo $curl_output | grep "< HTTP/1.1 301"|wc -l|sed 's/ //g'`
if [ $test_redirect -eq 1 ]; then
    echo ">>> Redirect 301 test passed successfully."
else
    echo ">>> TEST FAILED: Redirect 301"
    TEST_STATUS="fail"
fi
#Test for 200 response
test_response_code=`echo $curl_output | grep "< HTTP/1.1 200"|wc -l|sed 's/ //g'`
if [ $test_response_code -eq 1 ]; then
    echo ">>> Response code 200 test passed successfully."
else
    echo ">>> TEST FAILED: Response code 200"
    TEST_STATUS="fail"
fi
#Test for CN
test_CN=`echo $curl_output | grep "subject: CN=kostasbotsas.com"|wc -l|sed 's/ //g'`
if [ $test_CN -eq 1 ]; then
    echo ">>> CN test passed successfully."
else
    echo ">>> TEST FAILED: CN not found"
    TEST_STATUS="fail"
fi

if [ $TEST_STATUS = "fail" ]; then
    echo "> Test Suite FAILED"
else
    echo "> Test Suite PASSED"
fi