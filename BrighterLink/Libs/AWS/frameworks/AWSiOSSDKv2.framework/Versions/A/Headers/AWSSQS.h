/*
 * Copyright 2010-2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <AWSiOSSDKv2/AWSService.h>
#import <AWSiOSSDKv2/AWSSQSModel.h>

@class BFTask;

/**
 * <p>Welcome to the <i>Amazon Simple Queue Service API Reference</i>. This section describes who should read this guide, how the guide is organized, and other resources related to the Amazon Simple Queue Service (Amazon SQS).</p><p>Amazon SQS offers reliable and scalable hosted queues for storing messages as they travel between computers. By using Amazon SQS, you can move data between distributed components of your applications that perform different tasks without losing messages or requiring each component to be always available.</p><p>Helpful Links: <ul><li><a href="http://queue.amazonaws.com/doc/2012-11-05/QueueService.wsdl">Current WSDL (2012-11-05)</a></li><li><a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/MakingRequestsArticle.html">Making API Requests</a></li><li><a href="http://aws.amazon.com/sqs/">Amazon SQS product page</a></li><li><a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/SQSDeadLetterQueue.html">Using Amazon SQS Dead Letter Queues</a></li><li><a href="http://docs.aws.amazon.com/general/latest/gr/rande.html#sqs_region">Regions and Endpoints</a></li></ul></p><p>We also provide SDKs that enable you to access Amazon SQS from your preferred programming language. The SDKs contain functionality that automatically takes care of tasks such as:</p><p><ul><li>Cryptographically signing your service requests</li><li>Retrying requests</li><li>Handling error responses</li></ul></p><p>For a list of available SDKs, go to <a href="http://aws.amazon.com/tools/">Tools for Amazon Web Services</a>.</p>
 */
@interface AWSSQS : AWSService

@property (nonatomic, strong, readonly) AWSServiceConfiguration *configuration;

+ (instancetype)defaultSQS;

- (instancetype)initWithConfiguration:(AWSServiceConfiguration *)configuration;

/**
 * <p>Adds a permission to a queue for a specific <a href="http://docs.aws.amazon.com/general/latest/gr/glos-chap.html#P">principal</a>. This allows for sharing access to the queue.</p><p>When you create a queue, you have full control access rights for the queue. Only you (as owner of the queue) can grant or deny permissions to the queue. For more information about these permissions, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/acp-overview.html">Shared Queues</a> in the <i>Amazon SQS Developer Guide</i>.</p><p><code>&amp;Attribute.1=this</code></p><p><code>&amp;Attribute.2=that</code></p>
 *
 * @param request A container for the necessary parameters to execute the AddPermission service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will be nil. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorOverLimit.
 *
 * @see AWSSQSAddPermissionRequest
 */
- (BFTask *)addPermission:(AWSSQSAddPermissionRequest *)request;

/**
 * <p>Changes the visibility timeout of a specified message in a queue to a new value. The maximum allowed timeout value you can set the value to is 12 hours. This means you can't extend the timeout of a message in an existing queue to more than a total visibility timeout of 12 hours. (For more information visibility timeout, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/AboutVT.html">Visibility Timeout</a> in the <i>Amazon SQS Developer Guide</i>.)</p><p>For example, let's say you have a message and its default message visibility timeout is 30 minutes. You could call <code>ChangeMessageVisiblity</code> with a value of two hours and the effective timeout would be two hours and 30 minutes. When that time comes near you could again extend the time out by calling ChangeMessageVisiblity, but this time the maximum allowed timeout would be 9 hours and 30 minutes.</p><important>If you attempt to set the <code>VisibilityTimeout</code> to an amount more than the maximum time left, Amazon SQS returns an error. It will not automatically recalculate and increase the timeout to the maximum time remaining.</important><important>Unlike with a queue, when you change the visibility timeout for a specific message, that timeout value is applied immediately but is not saved in memory for that message. If you don't delete a message after it is received, the visibility timeout for the message the next time it is received reverts to the original timeout value, not the value you set with the <code>ChangeMessageVisibility</code> action.</important>
 *
 * @param request A container for the necessary parameters to execute the ChangeMessageVisibility service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will be nil. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorMessageNotInflight, AWSSQSErrorReceiptHandleIsInvalid.
 *
 * @see AWSSQSChangeMessageVisibilityRequest
 */
- (BFTask *)changeMessageVisibility:(AWSSQSChangeMessageVisibilityRequest *)request;

/**
 * <p>Changes the visibility timeout of multiple messages. This is a batch version of <a>ChangeMessageVisibility</a>. The result of the action on each message is reported individually in the response. You can send up to 10 <a>ChangeMessageVisibility</a> requests with each <code>ChangeMessageVisibilityBatch</code> action.</p><important>Because the batch request can result in a combination of successful and unsuccessful actions, you should check for batch errors even when the call returns an HTTP status code of 200.</important><p><code>&amp;Attribute.1=this</code></p><p><code>&amp;Attribute.2=that</code></p>
 *
 * @param request A container for the necessary parameters to execute the ChangeMessageVisibilityBatch service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will contain an instance of AWSSQSChangeMessageVisibilityBatchResult. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorTooManyEntriesInBatchRequest, AWSSQSErrorEmptyBatchRequest, AWSSQSErrorBatchEntryIdsNotDistinct, AWSSQSErrorInvalidBatchEntryId.
 *
 * @see AWSSQSChangeMessageVisibilityBatchRequest
 * @see AWSSQSChangeMessageVisibilityBatchResult
 */
- (BFTask *)changeMessageVisibilityBatch:(AWSSQSChangeMessageVisibilityBatchRequest *)request;

/**
 * <p>Creates a new queue, or returns the URL of an existing one. When you request <code>CreateQueue</code>, you provide a name for the queue. To successfully create a new queue, you must provide a name that is unique within the scope of your own queues.</p><p>You may pass one or more attributes in the request. If you do not provide a value for any attribute, the queue will have the default value for that attribute. Permitted attributes are the same that can be set using <a>SetQueueAttributes</a>.</p><p>If you provide the name of an existing queue, along with the exact names and values of all the queue's attributes, <code>CreateQueue</code> returns the queue URL for the existing queue. If the queue name, attribute names, or attribute values do not match an existing queue, <code>CreateQueue</code> returns an error.</p><p><code>&amp;Attribute.1=this</code></p><p><code>&amp;Attribute.2=that</code></p>
 *
 * @param request A container for the necessary parameters to execute the CreateQueue service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will contain an instance of AWSSQSCreateQueueResult. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorQueueDeletedRecently, AWSSQSErrorQueueNameExists.
 *
 * @see AWSSQSCreateQueueRequest
 * @see AWSSQSCreateQueueResult
 */
- (BFTask *)createQueue:(AWSSQSCreateQueueRequest *)request;

/**
 * <p> Deletes the specified message from the specified queue. You specify the message by using the message's <code>receipt handle</code> and not the <code>message ID</code> you received when you sent the message. Even if the message is locked by another reader due to the visibility timeout setting, it is still deleted from the queue. If you leave a message in the queue for longer than the queue's configured retention period, Amazon SQS automatically deletes it. </p><important><p> It is possible you will receive a message even after you have deleted it. This might happen on rare occasions if one of the servers storing a copy of the message is unavailable when you request to delete the message. The copy remains on the server and might be returned to you again on a subsequent receive request. You should create your system to be idempotent so that receiving a particular message more than once is not a problem. </p></important>
 *
 * @param request A container for the necessary parameters to execute the DeleteMessage service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will be nil. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorInvalidIdFormat, AWSSQSErrorReceiptHandleIsInvalid.
 *
 * @see AWSSQSDeleteMessageRequest
 */
- (BFTask *)deleteMessage:(AWSSQSDeleteMessageRequest *)request;

/**
 * <p>Deletes multiple messages. This is a batch version of <a>DeleteMessage</a>. The result of the delete action on each message is reported individually in the response.</p><important><p> Because the batch request can result in a combination of successful and unsuccessful actions, you should check for batch errors even when the call returns an HTTP status code of 200. </p></important><p><code>&amp;Attribute.1=this</code></p><p><code>&amp;Attribute.2=that</code></p>
 *
 * @param request A container for the necessary parameters to execute the DeleteMessageBatch service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will contain an instance of AWSSQSDeleteMessageBatchResult. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorTooManyEntriesInBatchRequest, AWSSQSErrorEmptyBatchRequest, AWSSQSErrorBatchEntryIdsNotDistinct, AWSSQSErrorInvalidBatchEntryId.
 *
 * @see AWSSQSDeleteMessageBatchRequest
 * @see AWSSQSDeleteMessageBatchResult
 */
- (BFTask *)deleteMessageBatch:(AWSSQSDeleteMessageBatchRequest *)request;

/**
 * <p> Deletes the queue specified by the <b>queue URL</b>, regardless of whether the queue is empty. If the specified queue does not exist, Amazon SQS returns a successful response. </p><important><p> Use <code>DeleteQueue</code> with care; once you delete your queue, any messages in the queue are no longer available. </p></important><p> When you delete a queue, the deletion process takes up to 60 seconds. Requests you send involving that queue during the 60 seconds might succeed. For example, a <a>SendMessage</a> request might succeed, but after the 60 seconds, the queue and that message you sent no longer exist. Also, when you delete a queue, you must wait at least 60 seconds before creating a queue with the same name. </p><p> We reserve the right to delete queues that have had no activity for more than 30 days. For more information, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/SQSConcepts.html">How Amazon SQS Queues Work</a> in the <i>Amazon SQS Developer Guide</i>. </p>
 *
 * @param request A container for the necessary parameters to execute the DeleteQueue service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will be nil.
 *
 * @see AWSSQSDeleteQueueRequest
 */
- (BFTask *)deleteQueue:(AWSSQSDeleteQueueRequest *)request;

/**
 * <p>Gets attributes for the specified queue. The following attributes are supported: <ul><li><code>All</code> - returns all values.</li><li><code>ApproximateNumberOfMessages</code> - returns the approximate number of visible messages in a queue. For more information, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/ApproximateNumber.html">Resources Required to Process Messages</a> in the <i>Amazon SQS Developer Guide</i>.</li><li><code>ApproximateNumberOfMessagesNotVisible</code> - returns the approximate number of messages that are not timed-out and not deleted. For more information, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/ApproximateNumber.html">Resources Required to Process Messages</a> in the <i>Amazon SQS Developer Guide</i>.</li><li><code>VisibilityTimeout</code> - returns the visibility timeout for the queue. For more information about visibility timeout, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/AboutVT.html">Visibility Timeout</a> in the <i>Amazon SQS Developer Guide</i>.</li><li><code>CreatedTimestamp</code> - returns the time when the queue was created (epoch time in seconds).</li><li><code>LastModifiedTimestamp</code> - returns the time when the queue was last changed (epoch time in seconds).</li><li><code>Policy</code> - returns the queue's policy.</li><li><code>MaximumMessageSize</code> - returns the limit of how many bytes a message can contain before Amazon SQS rejects it.</li><li><code>MessageRetentionPeriod</code> - returns the number of seconds Amazon SQS retains a message.</li><li><code>QueueArn</code> - returns the queue's Amazon resource name (ARN).</li><li><code>ApproximateNumberOfMessagesDelayed</code> - returns the approximate number of messages that are pending to be added to the queue.</li><li><code>DelaySeconds</code> - returns the default delay on the queue in seconds.</li><li><code>ReceiveMessageWaitTimeSeconds</code> - returns the time for which a ReceiveMessage call will wait for a message to arrive.</li><li><code>RedrivePolicy</code> - returns the parameters for dead letter queue functionality of the source queue. For more information about RedrivePolicy and dead letter queues, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/SQSDeadLetterQueue.html">Using Amazon SQS Dead Letter Queues</a> in the <i>Amazon SQS Developer Guide</i>.</li></ul></p><p><code>&amp;Attribute.1=this</code></p><p><code>&amp;Attribute.2=that</code></p>
 *
 * @param request A container for the necessary parameters to execute the GetQueueAttributes service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will contain an instance of AWSSQSGetQueueAttributesResult. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorInvalidAttributeName.
 *
 * @see AWSSQSGetQueueAttributesRequest
 * @see AWSSQSGetQueueAttributesResult
 */
- (BFTask *)getQueueAttributes:(AWSSQSGetQueueAttributesRequest *)request;

/**
 * <p> Returns the URL of an existing queue. This action provides a simple way to retrieve the URL of an Amazon SQS queue. </p><p> To access a queue that belongs to another AWS account, use the <code>QueueOwnerAWSAccountId</code> parameter to specify the account ID of the queue's owner. The queue's owner must grant you permission to access the queue. For more information about shared queue access, see <a>AddPermission</a> or go to <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/acp-overview.html">Shared Queues</a> in the <i>Amazon SQS Developer Guide</i>. </p>
 *
 * @param request A container for the necessary parameters to execute the GetQueueUrl service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will contain an instance of AWSSQSGetQueueUrlResult. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorQueueDoesNotExist.
 *
 * @see AWSSQSGetQueueUrlRequest
 * @see AWSSQSGetQueueUrlResult
 */
- (BFTask *)getQueueUrl:(AWSSQSGetQueueUrlRequest *)request;

/**
 * <p>Returns a list of your queues that have the RedrivePolicy queue attribute configured with a dead letter queue.</p><p>For more information about using dead letter queues, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/SQSDeadLetterQueue.html">Using Amazon SQS Dead Letter Queues</a>.</p>
 *
 * @param request A container for the necessary parameters to execute the ListDeadLetterSourceQueues service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will contain an instance of AWSSQSListDeadLetterSourceQueuesResult. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorQueueDoesNotExist.
 *
 * @see AWSSQSListDeadLetterSourceQueuesRequest
 * @see AWSSQSListDeadLetterSourceQueuesResult
 */
- (BFTask *)listDeadLetterSourceQueues:(AWSSQSListDeadLetterSourceQueuesRequest *)request;

/**
 * <p>Returns a list of your queues. The maximum number of queues that can be returned is 1000. If you specify a value for the optional <code>QueueNamePrefix</code> parameter, only queues with a name beginning with the specified value are returned.</p>
 *
 * @param request A container for the necessary parameters to execute the ListQueues service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will contain an instance of AWSSQSListQueuesResult.
 *
 * @see AWSSQSListQueuesRequest
 * @see AWSSQSListQueuesResult
 */
- (BFTask *)listQueues:(AWSSQSListQueuesRequest *)request;

/**
 * <p> Retrieves one or more messages, with a maximum limit of 10 messages, from the specified queue. Long poll support is enabled by using the <code>WaitTimeSeconds</code> parameter. For more information, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-long-polling.html">Amazon SQS Long Poll</a> in the <i>Amazon SQS Developer Guide</i>. </p><p> Short poll is the default behavior where a weighted random set of machines is sampled on a <code>ReceiveMessage</code> call. This means only the messages on the sampled machines are returned. If the number of messages in the queue is small (less than 1000), it is likely you will get fewer messages than you requested per <code>ReceiveMessage</code> call. If the number of messages in the queue is extremely small, you might not receive any messages in a particular <code>ReceiveMessage</code> response; in which case you should repeat the request. </p><p> For each message returned, the response includes the following: </p><ul><li><p> Message body </p></li><li><p> MD5 digest of the message body. For information about MD5, go to <a href="http://www.faqs.org/rfcs/rfc1321.html">http://www.faqs.org/rfcs/rfc1321.html</a>. </p></li><li><p> Message ID you received when you sent the message to the queue. </p></li><li><p> Receipt handle. </p></li><li><p> Message attributes. </p></li><li><p> MD5 digest of the message attributes. </p></li></ul><p> The receipt handle is the identifier you must provide when deleting the message. For more information, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/ImportantIdentifiers.html">Queue and Message Identifiers</a> in the <i>Amazon SQS Developer Guide</i>. </p><p> You can provide the <code>VisibilityTimeout</code> parameter in your request, which will be applied to the messages that Amazon SQS returns in the response. If you do not include the parameter, the overall visibility timeout for the queue is used for the returned messages. For more information, see <a href="http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/AboutVT.html">Visibility Timeout</a> in the <i>Amazon SQS Developer Guide</i>. </p>
 *
 * @param request A container for the necessary parameters to execute the ReceiveMessage service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will contain an instance of AWSSQSReceiveMessageResult. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorOverLimit.
 *
 * @see AWSSQSReceiveMessageRequest
 * @see AWSSQSReceiveMessageResult
 */
- (BFTask *)receiveMessage:(AWSSQSReceiveMessageRequest *)request;

/**
 * <p>Revokes any permissions in the queue policy that matches the specified <code>Label</code> parameter. Only the owner of the queue can remove permissions.</p>
 *
 * @param request A container for the necessary parameters to execute the RemovePermission service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will be nil.
 *
 * @see AWSSQSRemovePermissionRequest
 */
- (BFTask *)removePermission:(AWSSQSRemovePermissionRequest *)request;

/**
 * <p> Delivers a message to the specified queue. With Amazon SQS, you now have the ability to send large payload messages that are up to 256KB (262,144 bytes) in size. To send large payloads, you must use an AWS SDK that supports SigV4 signing. To verify whether SigV4 is supported for an AWS SDK, check the SDK release notes. </p><important><p> The following list shows the characters (in Unicode) allowed in your message, according to the W3C XML specification. For more information, go to <a href="http://www.w3.org/TR/REC-xml/#charsets">http://www.w3.org/TR/REC-xml/#charsets</a> If you send any characters not included in the list, your request will be rejected. </p><p> #x9 | #xA | #xD | [#x20 to #xD7FF] | [#xE000 to #xFFFD] | [#x10000 to #x10FFFF] </p></important>
 *
 * @param request A container for the necessary parameters to execute the SendMessage service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will contain an instance of AWSSQSSendMessageResult. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorInvalidMessageContents, AWSSQSErrorUnsupportedOperation.
 *
 * @see AWSSQSSendMessageRequest
 * @see AWSSQSSendMessageResult
 */
- (BFTask *)sendMessage:(AWSSQSSendMessageRequest *)request;

/**
 * <p>Delivers up to ten messages to the specified queue. This is a batch version of <a>SendMessage</a>. The result of the send action on each message is reported individually in the response. The maximum allowed individual message size is 256 KB (262,144 bytes).</p><p>The maximum total payload size (i.e., the sum of all a batch's individual message lengths) is also 256 KB (262,144 bytes).</p><p>If the <code>DelaySeconds</code> parameter is not specified for an entry, the default for the queue is used.</p><important>The following list shows the characters (in Unicode) that are allowed in your message, according to the W3C XML specification. For more information, go to <a href="http://www.faqs.org/rfcs/rfc1321.html">http://www.faqs.org/rfcs/rfc1321.html</a>. If you send any characters that are not included in the list, your request will be rejected. <p>#x9 | #xA | #xD | [#x20 to #xD7FF] | [#xE000 to #xFFFD] | [#x10000 to #x10FFFF]</p></important><important> Because the batch request can result in a combination of successful and unsuccessful actions, you should check for batch errors even when the call returns an HTTP status code of 200. </important><p><code>&amp;Attribute.1=this</code></p><p><code>&amp;Attribute.2=that</code></p>
 *
 * @param request A container for the necessary parameters to execute the SendMessageBatch service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will contain an instance of AWSSQSSendMessageBatchResult. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorTooManyEntriesInBatchRequest, AWSSQSErrorEmptyBatchRequest, AWSSQSErrorBatchEntryIdsNotDistinct, AWSSQSErrorBatchRequestTooLong, AWSSQSErrorInvalidBatchEntryId, AWSSQSErrorUnsupportedOperation.
 *
 * @see AWSSQSSendMessageBatchRequest
 * @see AWSSQSSendMessageBatchResult
 */
- (BFTask *)sendMessageBatch:(AWSSQSSendMessageBatchRequest *)request;

/**
 * <p>Sets the value of one or more queue attributes. When you change a queue's attributes, the change can take up to 60 seconds for most of the attributes to propagate throughout the SQS system. Changes made to the <code>MessageRetentionPeriod</code> attribute can take up to 15 minutes.</p>
 *
 * @param request A container for the necessary parameters to execute the SetQueueAttributes service method.
 *
 * @return An instance of BFTask. On successful execution, task.result will be nil. On failed execution, task.error may contain an NSError with AWSSQSErrorDomain domian and the following error code: AWSSQSErrorInvalidAttributeName.
 *
 * @see AWSSQSSetQueueAttributesRequest
 */
- (BFTask *)setQueueAttributes:(AWSSQSSetQueueAttributesRequest *)request;

@end
