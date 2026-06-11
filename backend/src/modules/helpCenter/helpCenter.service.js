const HelpFeedback = require("../../models/helpFeedback.model");

const supportTopics = [
  {
    name: "Thú cưng",
    detail: "Chăm sóc, sức khỏe, hành vi và hồ sơ thú cưng.",
    icon: "pets",
    imageUrl:
      "https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=1200&q=80",
    supportInfo: [
      { label: "Tên chương trình", value: "Hỗ trợ vật nuôi" },
      { label: "Đối tượng hỗ trợ", value: "Chó, mèo và thú cưng khác" },
      {
        label: "Loại hỗ trợ",
        value: "Chi phí khám chữa bệnh, tiêm phòng, thức ăn...",
      },
      { label: "Hình thức hỗ trợ", value: "Hỗ trợ một phần chi phí" },
      { label: "Thời gian hỗ trợ", value: "01/01/2024 - 31/12/2024" },
      { label: "Địa điểm áp dụng", value: "Toàn quốc" },
    ],
    programDescription:
      "Chương trình hỗ trợ dành cho thú cưng của các hộ gia đình có hoàn cảnh khó khăn. Hỗ trợ một phần chi phí khám chữa bệnh, tiêm phòng định kỳ và thức ăn cho thú cưng nhằm giúp các bé luôn khỏe mạnh và được chăm sóc tốt hơn.",
    actionLabel: "Đăng ký hỗ trợ",
  },
  {
    name: "Đặt lịch & dịch vụ",
    detail: "Đặt lịch, thay đổi lịch, hủy lịch và chọn dịch vụ.",
    icon: "booking",
    imageUrl:
      "https://images.unsplash.com/photo-1601758124510-52d02ddb7cbd?auto=format&fit=crop&w=1200&q=80",
    supportInfo: [
      { label: "Tên chương trình", value: "Hỗ trợ đặt lịch dịch vụ" },
      { label: "Đối tượng hỗ trợ", value: "Khách hàng PawSitive Care" },
      {
        label: "Loại hỗ trợ",
        value: "Đặt lịch, đổi lịch, hủy lịch và tư vấn dịch vụ",
      },
      { label: "Hình thức hỗ trợ", value: "Hướng dẫn trực tuyến và tổng đài" },
      { label: "Thời gian hỗ trợ", value: "08:00 - 21:00 hằng ngày" },
      { label: "Địa điểm áp dụng", value: "TPHCM và khu vực hỗ trợ" },
    ],
    programDescription:
      "Chương trình hỗ trợ khách hàng thao tác đặt lịch, chọn dịch vụ phù hợp, thay đổi thời gian hẹn và xử lý các vấn đề phát sinh trong quá trình sử dụng dịch vụ chăm sóc thú cưng.",
    actionLabel: "Đăng ký hỗ trợ",
  },
  {
    name: "Thanh toán",
    detail: "Ví Pawtitive, giao dịch, hóa đơn và hoàn tiền.",
    icon: "payment",
    imageUrl:
      "https://images.unsplash.com/photo-1554224155-6726b3ff858f?auto=format&fit=crop&w=1200&q=80",
    supportInfo: [
      { label: "Tên chương trình", value: "Hỗ trợ thanh toán" },
      { label: "Đối tượng hỗ trợ", value: "Khách hàng có giao dịch trên app" },
      {
        label: "Loại hỗ trợ",
        value: "Thanh toán, hóa đơn, ví Pawtitive và hoàn tiền",
      },
      { label: "Hình thức hỗ trợ", value: "Kiểm tra giao dịch và phản hồi" },
      { label: "Thời gian hỗ trợ", value: "Trong vòng 1 - 3 ngày làm việc" },
      { label: "Địa điểm áp dụng", value: "Toàn quốc" },
    ],
    programDescription:
      "Chương trình hỗ trợ người dùng kiểm tra trạng thái thanh toán, đối soát giao dịch, xử lý hóa đơn và tiếp nhận yêu cầu hoàn tiền khi lịch hẹn hoặc dịch vụ phát sinh thay đổi.",
    actionLabel: "Gửi yêu cầu hỗ trợ",
  },
  {
    name: "Tài khoản & bảo mật",
    detail: "Thông tin tài khoản, đăng nhập và bảo mật.",
    icon: "security",
    imageUrl:
      "https://images.unsplash.com/photo-1563013544-824ae1b704d3?auto=format&fit=crop&w=1200&q=80",
    supportInfo: [
      { label: "Tên chương trình", value: "Hỗ trợ tài khoản" },
      { label: "Đối tượng hỗ trợ", value: "Người dùng PawSitive Care" },
      {
        label: "Loại hỗ trợ",
        value: "Đăng nhập, bảo mật, cập nhật thông tin cá nhân",
      },
      { label: "Hình thức hỗ trợ", value: "Xác minh và hướng dẫn bảo mật" },
      { label: "Thời gian hỗ trợ", value: "24/7 với vấn đề đăng nhập" },
      { label: "Địa điểm áp dụng", value: "Toàn quốc" },
    ],
    programDescription:
      "Chương trình hỗ trợ người dùng bảo vệ tài khoản, cập nhật thông tin cá nhân, khôi phục đăng nhập và xử lý các cảnh báo bảo mật để trải nghiệm sử dụng app an toàn hơn.",
    actionLabel: "Yêu cầu hỗ trợ",
  },
];

const faqs = [
  {
    id: "book-service",
    title: "Làm thế nào để đặt lịch dịch vụ?",
    imageUrl:
      "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=1200&q=80",
    description:
      "Bạn có thể đặt lịch nhanh bằng cách chọn thú cưng, dịch vụ, ngày và khung giờ còn trống.",
    detail:
      "Vào mục Dịch vụ hoặc Đặt lịch, chọn thú cưng cần sử dụng dịch vụ, chọn một hoặc nhiều dịch vụ phù hợp, sau đó chọn ngày và khung giờ. Nếu khung giờ đã có người đặt, app sẽ khóa lại để tránh trùng lịch. Sau khi xác nhận, hệ thống sẽ lưu lịch hẹn vào tài khoản của bạn.",
  },
  {
    id: "payment-methods",
    title: "Phương thức thanh toán nào được chấp nhận?",
    imageUrl:
      "https://images.unsplash.com/photo-1554224154-26032fced8bd?auto=format&fit=crop&w=1200&q=80",
    description:
      "PawSitive Care hỗ trợ thanh toán bằng tiền mặt và các phương thức điện tử theo từng giai đoạn triển khai.",
    detail:
      "Ở giai đoạn hiện tại, bạn có thể kiểm tra tổng chi phí trước khi xác nhận lịch. Khi hệ thống thanh toán online được kích hoạt, app sẽ hiển thị thêm ví điện tử, chuyển khoản hoặc thẻ tùy theo cấu hình của cửa hàng.",
  },
  {
    id: "cancel-or-change-booking",
    title: "Tôi có thể hủy hoặc đổi lịch hẹn không?",
    imageUrl:
      "https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?auto=format&fit=crop&w=1200&q=80",
    description:
      "Bạn có thể hủy lịch trong chi tiết lịch hẹn nếu lịch chưa hoàn tất hoặc chưa bị khóa xử lý.",
    detail:
      "Mở Lịch sử đặt chỗ, chọn lịch hẹn cần xử lý và bấm Hủy lịch. Trạng thái lịch sẽ được cập nhật trên server. Với đổi lịch, bạn nên hủy lịch cũ rồi tạo lịch mới ở khung giờ còn trống để tránh trùng lịch với người dùng khác.",
  },
  {
    id: "contact-support",
    title: "Làm thế nào để liên hệ với hỗ trợ?",
    imageUrl:
      "https://images.unsplash.com/photo-1556745757-8d76bdb6984b?auto=format&fit=crop&w=1200&q=80",
    description:
      "Bạn có thể gọi trực tiếp tổng đài hoặc gửi yêu cầu hỗ trợ ngay trong app.",
    detail:
      "Tại Trung tâm trợ giúp, bấm Liên hệ ngay để gọi số hỗ trợ. Nếu vấn đề không khẩn cấp, bạn có thể bấm Gửi yêu cầu, nhập nội dung cần hỗ trợ và hệ thống sẽ lưu feedback để đội ngũ xử lý sau.",
  },
  {
    id: "add-new-pet",
    title: "Làm sao để thêm thú cưng mới?",
    imageUrl:
      "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=1200&q=80",
    description:
      "Bạn có thể thêm thú cưng từ Profile hoặc từ luồng đặt lịch.",
    detail:
      "Vào Profile, chọn Thú cưng của tôi, bấm Thêm thú cưng rồi nhập ảnh, loại thú cưng, tên, tuổi, cân nặng và tình trạng vaccine. Khi lưu thành công, thông tin sẽ được gửi lên API pet và lưu trong MongoDB theo tài khoản của bạn.",
  },
];

const getHelpCenter = () => ({
  contactPhone: "0903972116",
  topics: supportTopics,
  faqs,
});

const createFeedback = async ({ userId, message }) => {
  const feedback = await HelpFeedback.create({
    user: userId || null,
    message,
  });

  return {
    id: feedback._id,
    message: feedback.message,
    status: feedback.status,
    createdAt: feedback.createdAt,
  };
};

module.exports = {
  createFeedback,
  getHelpCenter,
};
