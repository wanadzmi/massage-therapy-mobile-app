import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/transaction_history_controller.dart';

class TransactionHistoryView extends GetView<TransactionHistoryController> {
  const TransactionHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFD4AF37)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading && controller.transactions.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
          );
        }

        return Column(
          children: [
            // Summary Card
            if (controller.summary != null) _buildSummaryCard(),

            // Filter Chips
            _buildFilterChips(),

            // Transaction List
            Expanded(
              child: controller.transactions.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      color: const Color(0xFFD4AF37),
                      backgroundColor: const Color(0xFF1A1A1A),
                      onRefresh: controller.refreshTransactions,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = controller.transactions[index];
                          return _buildTransactionCard(transaction);
                        },
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCard() {
    final summary = controller.summary!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Total Credits',
                  '+RM${summary.totalCredits.toStringAsFixed(2)}',
                  const Color(0xFF4CAF50),
                  '${summary.creditCount} transactions',
                ),
              ),
              Container(width: 1, height: 40, color: const Color(0xFF2A2A2A)),
              Expanded(
                child: _buildSummaryItem(
                  'Total Debits',
                  '-RM${summary.totalDebits.toStringAsFixed(2)}',
                  const Color(0xFFFF5252),
                  '${summary.debitCount} transactions',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String amount,
    Color color,
    String count,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF808080), fontSize: 12),
        ),
        const SizedBox(height: 8),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(color: Color(0xFF606060), fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Obx(() => _buildFilterChip('All', 'all')),
          const SizedBox(width: 8),
          Obx(() => _buildFilterChip('Top Up', 'top_up')),
          const SizedBox(width: 8),
          Obx(() => _buildFilterChip('Payment', 'payment')),
          const SizedBox(width: 8),
          Obx(() => _buildFilterChip('Cashback', 'cashback')),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = controller.selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => controller.filterByType(value),
      backgroundColor: const Color(0xFF1A1A1A),
      selectedColor: const Color(0xFFD4AF37).withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF808080),
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: isSelected ? const Color(0xFFD4AF37) : const Color(0xFF2A2A2A),
      ),
    );
  }

  Widget _buildTransactionCard(transaction) {
    final isCredit = transaction.direction == 'credit';
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showTransactionDetails(transaction),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        (isCredit
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFF5252))
                            .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      controller.getTransactionIcon(transaction),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.description,
                        style: const TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              dateFormat.format(transaction.createdAt),
                              style: const TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (transaction.topUp?.method != null ||
                              transaction.relatedPayment?.method != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                controller.getPaymentMethodLabel(
                                  transaction.topUp?.method ??
                                      transaction.relatedPayment?.method,
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      transaction.formattedAmount,
                      style: TextStyle(
                        color: isCredit
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFFF5252),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          transaction.status,
                        ).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        transaction.status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(transaction.status),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: const Icon(
              Icons.receipt_long,
              size: 60,
              color: Color(0xFF808080),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Transactions Yet',
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your transaction history will appear here',
            style: TextStyle(color: Color(0xFF808080), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFFFFA726);
      case 'failed':
        return const Color(0xFFFF5252);
      default:
        return const Color(0xFF808080);
    }
  }

  void _showTransactionDetails(transaction) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Transaction Details',
                style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Transaction ID', transaction.transactionId),
              _buildDetailRow('Type', transaction.type.toUpperCase()),
              _buildDetailRow('Category', transaction.category.toUpperCase()),
              _buildDetailRow('Amount', transaction.formattedAmount),
              _buildDetailRow('Status', transaction.status.toUpperCase()),
              _buildDetailRow(
                'Balance Before',
                'RM${transaction.balanceBefore.toStringAsFixed(2)}',
              ),
              _buildDetailRow(
                'Balance After',
                'RM${transaction.balanceAfter.toStringAsFixed(2)}',
              ),
              _buildDetailRow(
                'Date',
                DateFormat(
                  'MMM dd, yyyy HH:mm:ss',
                ).format(transaction.createdAt),
              ),
              if (transaction.topUp?.gatewayTransactionId != null)
                _buildDetailRow(
                  'Gateway ID',
                  transaction.topUp!.gatewayTransactionId!,
                ),
              if (transaction.relatedPayment?.gateway?.transactionId != null)
                _buildDetailRow(
                  'Gateway ID',
                  transaction.relatedPayment!.gateway!.transactionId,
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF808080), fontSize: 14),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
